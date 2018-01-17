#
# Copyright (C) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

#
# Recipe to install and configure the New Relic Infrastructure agent on Windows
#
# Chef uses sha256 checksums, to generate this, I downloaded the file
# and on OS X did 'shasum -a 256 newrelic-infra.msi' YMMV on other
# platforms. It'd be *really* cool if NewRelic could provide an API
# that you could ask for checksum values, or have checksums published
# and available in some other way.
#
# TODO: make install location configurable

windows_package 'newrelic-infra' do
  action :install
  checksum node['newrelic-infra']['windows_checksum']
  installer_type :msi
  retries node['newrelic_infra']['packages']['agent']['retries']
  source node['newrelic-infra']['windows_source']
end

# Build the New Relic infrastructure agent configuration
file 'C:\Program Files\New Relic\newrelic-infra\newrelic-infra.yml' do
  content(lazy do
    YAML.dump(
      node['newrelic_infra']['config'].to_h.deep_stringify.delete_blank
    )
  end)
  sensitive true
  notifies :restart, 'service[newrelic-infra]'
end

# Setup newrelic-infra service
service 'newrelic-infra' do
  action [:enable, :start]
end
