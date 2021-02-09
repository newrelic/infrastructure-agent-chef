#
# Copyright (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

#
# Recipe to install and configure the New Relic Infrastructure agent on Linux
# TODO: Convert to custom resource
#
node.default['newrelic_infra']['agent']['flags']['config'] = ::File.join(
  node['newrelic_infra']['agent']['directory']['path'],
  node['newrelic_infra']['agent']['config']['file']
)

# Setup a service account
poise_service_user node['newrelic_infra']['user']['name'] do
  group node['newrelic_infra']['group']['name']
  only_if { node['newrelic_infra']['features']['manage_service_account'] }
end

# Based on the Ohai attribute `platform_family` either an APT or YUM repository
# will be created. The respective Chef resources are built using metaprogramming,
# so that the configuration can be extended via attributes without having to
# release a new version of the cookbook. Attributes that cannot be passed to the resource
# are logged out as warnings in order to prevent potential failes from typos,
# older Chef versions, etc.
case node['newrelic_infra']['provider']
when 'package_manager'
  case node['platform_family']
  when 'debian'
    # Create APT repo file
    apt_repository cookbook_name do |apt_resource|
      node['newrelic_infra']['apt'].each do |property, value|
        unless apt_resource.class.properties.include?(property.to_sym) && !value.nil? || property == 'action'
          Chef::Log.warn("[#{cookbook_name}::#{recipe_name}] #{property} with #{value}" \
                         'is not valid for the Chef resource `apt_repository`!')
          next
        end

        apt_resource.send(property, value)
      end
    end
  when 'rhel', 'amazon'
    yum_repository cookbook_name do |yum_resource|
      node['newrelic_infra']['yum'].each do |property, value|
        unless yum_resource.class.properties.include?(property.to_sym) && !value.nil? || property == 'action'
          Chef::Log.warn("[#{cookbook_name}::#{recipe_name}] #{property} with #{value}" \
                         'is not valid for the Chef resource `yum_repository`!')
          next
        end

        yum_resource.send(property, value)
      end
    end
  when 'suse', 'sles'
    zypper_repository cookbook_name do |zypper_resource|
      node['newrelic_infra']['zypper'].each do |property, value|
        unless zypper_resource.class.properties.include?(property.to_sym) && !value.nil? || property == 'action'
          Chef::Log.warn("[#{cookbook_name}::#{recipe_name}] #{property} with #{value}" \
                         'is not valid for the Chef resource `zypper_repository`!')
          next
        end

        zypper_resource.send(property, value)
      end
    end
  end

  # Install the newrelic-infra agent
  package 'newrelic-infra' do
    action node['newrelic_infra']['packages']['agent']['action']
    retries node['newrelic_infra']['packages']['agent']['retries']
    version node['newrelic_infra']['packages']['agent']['version'].to_s
  end

  include_recipe 'newrelic-infra::host_integrations'

  # Fix for docker centos6 run
  execute 'reload_initctl_conf' do
    command 'initctl reload-configuration'
    only_if { node['platform_version'] =~ /^6/ }
    only_if { ::File.exist?('/.dockerenv') }
  end

  # Create and manage the agent directory
  directory node['newrelic_infra']['agent']['directory']['path'] do
    owner node['newrelic_infra']['user']['name']
    group node['newrelic_infra']['group']['name']
    mode node['newrelic_infra']['agent']['directory']['mode']
  end

  # Build the New Relic infrastructure agent configuration
  file node['newrelic_infra']['agent']['flags']['config'] do
    content(lazy do
      YAML.dump(
        node['newrelic_infra']['config'].to_h.deep_stringify.delete_blank
      )
    end)
    owner node['newrelic_infra']['user']['name']
    group node['newrelic_infra']['group']['name']
    mode  '0640'
    sensitive true
    notifies :restart, 'poise_service[newrelic-infra]'
  end

  # Enable and start the agent as a service on the node with any available
  # CLI options
  poise_service 'newrelic-infra' do
    # TODO: Figure out how to run as a service account.
    # user node['newrelic_infra']['user']['name']
    command '/usr/bin/newrelic-infra ' <<
            NewRelicInfra.generate_flags(node['newrelic_infra']['agent']['flags'])
    options(:systemd,
            template: 'newrelic-infra:default/systemd.service.erb',
            after: %w(syslog.target network.target))
  end
when 'tarball'
  node['newrelic_infra']['tarball'].tap do |conf|
    remote_file "/opt/linux_#{conf['version']}_#{conf['architecture']}.tar.gz" do
      source "https://download.newrelic.com/infrastructure_agent/binaries/linux/#{conf['architecture']}/newrelic-infra_linux_#{conf['version']}_#{conf['architecture']}.tar.gz"
      action :create
    end
    directory '/opt/newrelic_infra/' do
      action :create
    end
    directory "/opt/newrelic_infra/linux_#{conf['version']}_#{conf['architecture']}" do
      action :create
    end

    execute 'extract_newrelic_infra_tarball' do
      command "tar -xzf /opt/linux_#{conf['version']}_#{conf['architecture']}.tar.gz -C /opt/newrelic_infra/linux_#{conf['version']}_#{conf['architecture']}/"
      not_if { File.exist?("/opt/newrelic_infra/linux_#{conf['version']}_#{conf['architecture']}/newrelic-infra") }
      notifies :run, 'execute[run_installation_script]', :immediately
    end

    execute 'run_installation_script' do
      command "/opt/newrelic_infra/linux_#{conf['version']}_#{conf['architecture']}/newrelic-infra/installer.sh"
      cwd "/opt/newrelic_infra/linux_#{conf['version']}_#{conf['architecture']}/newrelic-infra/"
      environment 'NRIA_LICENSE_KEY' => node['newrelic_infra']['config']['license_key']
      action :nothing
    end
  end

  # Build the New Relic infrastructure agent configuration
  file '/etc/newrelic-infra.yml' do
    content(lazy do
      YAML.dump(
        node['newrelic_infra']['config'].to_h.deep_stringify.delete_blank
      )
    end)
    owner node['newrelic_infra']['user']['name']
    group node['newrelic_infra']['group']['name']
    mode  '0640'
    sensitive true
    notifies :restart, 'service[newrelic-infra]'
  end

  service 'newrelic-infra' do
    action :start
  end
end
