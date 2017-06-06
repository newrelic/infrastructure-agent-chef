# Installs and configures the New Relic Infrastructure agent on Windows
#
# Chef uses sha256 checksums, to generate this, I downloaded the file
# and on OS X did 'shasum -a 256 newrelic-infra.msi' YMMV on other
# platforms
#
# TODO: pin to specific version
# TODO: abstract checksum
# TODO: make install location configurable

windows_package 'newrelic-infra' do
  action :install
  source 'https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.msi'
  checksum '3c9f98325dc484ee8735f01b913803eaef54f06641348b3dd9f3c0b3cd803ace'
  installer_type :msi
end
# Lay down newrelic-infra agent config
template 'C:\Program Files\New Relic\newrelic-infra\newrelic-infra.yml' do
  source 'newrelic-infra.yml.erb'
  variables(
    'license_key' => node['newrelic-infra']['license_key'],
    'display_name' => node['newrelic-infra']['display_name'],
    'log_file' => node['newrelic-infra']['log_file'],
    'verbose' => node['newrelic-infra']['verbose'],
    'proxy' => node['newrelic-infra']['proxy']
  )
  notifies :restart, 'service[newrelic-infra]', :delayed
end
# Setup newrelic-infra service
service "newrelic-infra" do
  action [:enable, :start]
end
