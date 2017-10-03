# Installs and configures the New Relic Infrastructure agent on Windows
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
    source node['newrelic-infra']['windows_source'] if node['newrelic-infra']['windows_source']    
    checksum node['newrelic-infra']['windows_checksum'] if node['newrelic-infra']['windows_checksum']
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
