name              'newrelic-infra'
maintainer        'New Relic, Inc'
maintainer_email  ''
license           'All rights reserved'
description       'Installs/Configures the New Relic Infrastructure agent ' \
                  'and on-host integrations'
long_description  IO.read(File.join(__dir__, 'README.md'))
source_url        'https://github.com/newrelic/infrastructure-agent-chef'
issues_url        'https://github.com/newrelic/infrastructure-agent-chef/issues'
version           '0.3.0'
chef_version      '>= 12.15'

# Platform support
supports 'amazon', '>= 2013.0'
supports 'debian', '>= 7.0'
supports 'ubuntu', '>= 12.04'
supports 'redhat', '>= 6.0'
supports 'oracle', '>= 6.0'
supports 'centos', '>= 6.0'

# Cookbook dependencies
depends 'poise-service', '~> 1.5'
depends 'poise-archive', '~> 1.5'
