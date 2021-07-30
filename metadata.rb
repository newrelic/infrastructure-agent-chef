name              'newrelic-infra'
maintainer        'New Relic, Inc'
maintainer_email  ''
license           'All rights reserved'
description       'Installs/Configures the New Relic Infrastructure agent ' \
                  'and on-host integrations'
long_description  IO.read(File.join(__dir__, 'README.md'))
source_url        'https://github.com/newrelic/infrastructure-agent-chef'
issues_url        'https://github.com/newrelic/infrastructure-agent-chef/issues'
version           '0.11.0'
chef_version      '>= 15'

# Platform support
supports 'amazon', '>= 2013.0'
supports 'debian', '>= 7.0'
supports 'ubuntu', '>= 16.04'
supports 'redhat', '>= 5.0'
supports 'oracle', '>= 6.0'
supports 'centos', '>= 5.0'
supports 'suse'
supports 'windows'
