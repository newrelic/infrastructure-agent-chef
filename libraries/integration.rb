module NewRelicInfraCookbook
  # Chef custom resource to install the New Relic infrastructure agent on a node.
  class Integration < ::Chef::Resource
    BASENAME_IGNORE = /(\.(t?(ar|gz|bz2?|xz)|zip))+$/

    resource_name :newrelic_infra_integration

    # register with the resource resolution system
    provides :newrelic_infra_integration

    allowed_actions :create, :remove
    default_action :create

    # Required properties
    property :instance, String, name_property: true, required: true, desired_state: false
    property :integration_name, String, required: true
    property :remote_url, String, required: true
    property :instances, Array, required: true
    property :commands, Hash, required: true

    # Optional properties
    property :description, [String, nil]
    property :cli_options, [Hash, nil]

    # Properties with defaults
    property :interval, Integer, default: 10, desired_state: false
    property :prefix, String, default: lazy { |r| ::File.join('integration', r.instance) }, desired_state: false
    property :install_method, %w(tarball binary), default: 'tarball', desired_state: false
    property :os, %w(linux), default: 'linux', desired_state: false
    property :protocol_version, Integer, default: 1, desired_state: false
    property :user, String, default: 'newrelic_infra', desired_state: false
    property :group, String, default: 'newrelic_infra', desired_state: false
    property :base_dir, String, default: '/var/db/newrelic-infra/custom-integrations', desired_state: false
    property :bin_dir, String, default: '/opt/newrelic-infra', desired_state: false
    property :bin, String, default: lazy { |r| ::File.join(r.bin_dir, r.name, ::File.basename(r.remote_url).gsub(BASENAME_IGNORE, '')) }, desired_state: false
    property :definition_file, String, default: lazy { |r| ::File.join(r.base_dir, ::File.basename(r.name) << '.yaml') }
    property :config_dir, String, default: '/etc/newrelic-infra/integrations.d/', desired_state: false
    property :config_file, String, default: lazy { |r| ::File.join(r.config_dir, ::File.basename(r.name) << '.yaml') }

    # Helper methods
    def definition_file_content
      @definition_file_content ||= {
        name: integration_name,
        protocol_version: protocol_version,
        os: os,
        description: description,
        commands: build_definition_commands,
      }
    end

    def build_definition_commands
      @build_definition_commands ||= commands.each_with_object({}) do |(command, args), object|
        object.store(
          command,
          command: args.to_a.unshift(bin),
          interval: interval,
          prefix: prefix
        )
      end
    end

    def config_file_content
      @config_file_content ||= {
        integration_name: integration_name,
        instances: instances.to_a,
      }
    end

    # Actions
    action :create do
      # Creates and manages the directory for the custom integration executable
      %W(
        #{new_resource.bin_dir}
        #{::File.join(new_resource.bin_dir, new_resource.name)}
      ).each do |dir|
        directory dir do
          owner new_resource.user
          group new_resource.group
          mode '0750'
          recursive true
        end
      end

      # Fetch the remote executable binary if the install method is set to `binary`
      remote_file new_resource.bin do
        user new_resource.user
        group new_resource.group
        source new_resource.remote_url
        only_if { new_resource.install_method == 'binary' }
      end

      # Fetch the remote executable tarball if the install method is set to `tarball`
      poise_archive new_resource.remote_url do
        destination ::File.join(new_resource.bin_dir, new_resource.name)
        keep_existing true
        only_if { new_resource.install_method == 'tarball' }
      end

      file new_resource.bin do
        owner new_resource.user
        group new_resource.group
        mode '0750'
      end

      # Generate both the definiton and configuration files for the custom
      # New Relic Infrastructure on-host integration
      %w(
        definition_file
        config_file
      ).each do |file_to_create|
        file_path = new_resource.send(:"#{file_to_create}")

        file file_to_create do
          owner new_resource.user
          group new_resource.group
          path file_path
          content(lazy do
            ::Chef::Recipe::NewRelicInfra.yaml_file_workaround(
              new_resource.send(:"#{file_to_create}_content").delete_blank.deep_stringify.to_yaml
            )
          end)
          sensitive true
          mode '0640'
        end
      end
    end

    action :remove do
      # Remove all of the resources for the New Relic Infrastructure
      # custom on-host integration
      %W(
        #{new_resource.bin}
        #{new_resource.definition_file}
        #{new_resource.config_file}
      ).each do |file_to_remove|
        file file_to_remove do
          action :delete
        end
      end
    end
  end
end
