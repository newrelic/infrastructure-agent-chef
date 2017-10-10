#
# Copyright (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

#
# Installs New Relic provided and custom on-host integrations
#
package 'newrelic-infra-integrations' do
  action node['newrelic_infra']['packages']['host_integrations']['action']
  version node['newrelic_infra']['packages']['host_integrations']['version'].to_s
  only_if { node['newrelic_infra']['features']['host_integrations'] }
end

# Generate configuration for the New Relic provided host integrations
node['newrelic_infra']['host_integrations']['config'].each do |integration_name, config|
  file ::File.join(node['newrelic_infra']['host_integrations']['config_dir'], "#{integration_name}.yaml") do
    content(lazy { YAML.dump(config.to_hash.compact.deep_stringify) })
    owner node['newrelic_infra']['user']['name']
    group node['newrelic_infra']['group']['name']
    mode  '0640'
    notifies :restart, 'poise_service[newrelic-infra]'
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
