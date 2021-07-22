#
# Copyright (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

#
# Installs New Relic provided and custom on-host integrations
#

# Install host integrations defined with attributes
if node['newrelic_infra']['features']['host_integrations'].any?
  node['newrelic_infra']['features']['host_integrations'].each do |integration_name|
    package integration_name do
      action node['newrelic_infra']['packages'][integration_name]['action']
      retries node['newrelic_infra']['packages'][integration_name]['retries']
      version node['newrelic_infra']['packages'][integration_name]['version']
    end
  end

  directory node['newrelic_infra']['host_integrations']['config_dir'] do
    owner node['newrelic_infra']['user']['name']
    group node['newrelic_infra']['group']['name']
    mode '0750'
  end

  # Generate configuration for the New Relic provided host integrations
  node['newrelic_infra']['host_integrations']['config'].each do |integration_name, config|
    file_path = ::File.join(
      node['newrelic_infra']['host_integrations']['config_dir'],
      "#{integration_name}.yaml"
    )

    file file_path do
      content(lazy do
        NewRelicInfra.yaml_file_workaround(
          config.to_h.delete_blank.deep_stringify.to_yaml,
          node['newrelic_infra']['delete_yaml_quotes']
        )
      end)
      owner node['newrelic_infra']['user']['name']
      group node['newrelic_infra']['group']['name']
      mode '0640'
      sensitive true
      notifies :restart, 'service[newrelic-infra]'
    end
  end
end

# Install any custom integrations defined with attributes
node['newrelic_infra']['custom_integrations'].each do |integration_name, config|
  newrelic_infra_integration integration_name do |infra_resource|
    config.each do |property, value|
      unless infra_resource.class.properties.include?(property.to_sym) && !value.nil? || property == 'action'
        Chef::Log.warn("[#{cookbook_name}::#{recipe_name}] #{property} with #{value}" \
                        'is not valid for the Chef resource `yum_repository`!')
        next
      end

      infra_resource.send(property, value)
    end
  end
end
