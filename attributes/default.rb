#
# Copyright (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

default['newrelic_infra']['provider'] = 'package_manager'
default['newrelic_infra']['tarball']['version'] = nil
default['newrelic_infra']['delete_yaml_quotes'] = true

default['newrelic_infra']['tarball']['architecture'] = case node['kernel']['machine']
                                                       when 'x86_64'
                                                         'amd64'
                                                       when 'i386'
                                                         '386'
                                                       else
                                                         node['kernel']['machine']
                                                       end

# Feature flags
# Whether or not to install the New Relic on-host integrations
default['newrelic_infra']['features']['host_integrations'] = []

# Service account attributes
# Name of the service account user
default['newrelic_infra']['user']['name'] = 'newrelic_infra'
# Name of the service account group
default['newrelic_infra']['group']['name'] = 'newrelic_infra'

# New Relic infrastructure agent configuration options
default['newrelic_infra']['config'].tap do |conf|
  # Account license key
  conf['license_key'] = nil
  # Override the auto-generated hostname for reporting
  conf['display_name'] = nil
  # Use a proxy to communicate with New Relic
  conf['proxy'] = nil
  # When set to 1, enables verbose logging for the agent
  conf['verbose'] = 0
  # Enable Golang debugging
  conf['debug'] = nil
  # To log to another location; when not set, the agent logs to the system log files
  conf['log_file'] = nil
  # A hash of custom attributes to annotate the data from this agent instance
  conf['custom_attributes'] = {}
end

# New Relic infrastructure agent configuration file and directory properties
default['newrelic_infra']['agent'].tap do |conf|
  conf['config']['file'] = 'newrelic-infra.yml'
  conf['config']['mode'] = '0640'
  conf['directory']['path'] = '/etc/'
end

# New Relic Infrastructure agent package configuration
default['newrelic_infra']['packages']['agent']['action'] = %i(install)
default['newrelic_infra']['packages']['agent']['retries'] = 0
default['newrelic_infra']['packages']['agent']['version'] = nil

# New Relic Infrastructure on-host integration package configuration
# NOTE: The package actions will only be performed if the integration has been
# added to the host_integrations features list
default['newrelic_infra']['packages']['nri-cassandra']['action'] = %i(install)
default['newrelic_infra']['packages']['nri-cassandra']['retries'] = 0
default['newrelic_infra']['packages']['nri-cassandra']['version'] = nil
default['newrelic_infra']['packages']['nri-mysql']['action'] = %i(install)
default['newrelic_infra']['packages']['nri-mysql']['retries'] = 0
default['newrelic_infra']['packages']['nri-mysql']['version'] = nil
default['newrelic_infra']['packages']['nri-redis']['action'] = %i(install)
default['newrelic_infra']['packages']['nri-redis']['retries'] = 0
default['newrelic_infra']['packages']['nri-redis']['version'] = nil
default['newrelic_infra']['packages']['nri-nginx']['action'] = %i(install)
default['newrelic_infra']['packages']['nri-nginx']['retries'] = 0
default['newrelic_infra']['packages']['nri-nginx']['version'] = nil
default['newrelic_infra']['packages']['nri-apache']['action'] = %i(install)
default['newrelic_infra']['packages']['nri-apache']['retries'] = 0
default['newrelic_infra']['packages']['nri-apache']['version'] = nil

# New Relic Infrastructure on-host integration configuration
default['newrelic_infra']['host_integrations']['config_dir'] = '/etc/newrelic-infra/integrations.d'
default['newrelic_infra']['host_integrations']['config'] = {}

# New Relic Infrastructure on-host custom integration configuration
default['newrelic_infra']['custom_integrations'] = {}

# apt repository configuration for Debian based hosts
# See https://docs.chef.io/resource_apt_repository.html for more information
default['newrelic_infra']['apt'].tap do |conf|
  conf['uri'] = 'https://download.newrelic.com/infrastructure_agent/linux/apt'
  conf['key'] = 'https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg'
  conf['distribution'] = (node['lsb'] || {})['codename'] # node['lsb'] is nil on windows, so set a default
  conf['components'] = %w(main)
  conf['arch'] = 'amd64'
  conf['action'] = %i(add)
end

# Package version to install for Windows based hosts
default['newrelic-infra']['windows_source'] = 'https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.msi'

# YUM repository configuration for RHEL based hosts
# See https://docs.chef.io/resource_yum_repository.html for more information
default['newrelic_infra']['yum'].tap do |conf|
  conf['description'] = 'New Relic Infrastructure'
  conf['baseurl'] = value_for_platform(
    amazon: {
      '= 2013' => 'https://download.newrelic.com/infrastructure_agent/linux/yum/el/6/x86_64',
      '> 2013.0' => 'https://download.newrelic.com/infrastructure_agent/linux/yum/el/6/x86_64',
      '= 2' => 'https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/$basearch',
    },
    %w(redhat oracle centos) => {
      default: "https://download.newrelic.com/infrastructure_agent/linux/yum/el/#{node['platform_version'].to_i}/x86_64",
    }
  )
  conf['gpgkey'] = 'https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg'
  conf['gpgcheck'] = true
  conf['repo_gpgcheck'] = node['platform_version'].to_i != 5
  conf['action'] = %i(create)
end

# Zypp repository configuration for SLES based hosts
# See https://docs.chef.io/resource_zypper_repository.html for more information
default['newrelic_infra']['zypper'].tap do |conf|
  platform_version =
    if node['platform_version'] =~ /^42/
      '12.4'
    else
      node['platform_version']
    end

  conf['description'] = 'New Relic Infrastructure'
  # TODO: Create a dokken image for SLES 12.4
  conf['baseurl'] = "https://download.newrelic.com/infrastructure_agent/linux/zypp/sles/#{platform_version}/x86_64"
  conf['gpgkey'] = 'https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg'
  conf['gpgcheck'] = true
  conf['repo_gpgcheck'] = true
  conf['action'] = %i(add)
end
