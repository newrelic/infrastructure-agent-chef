# Detects platform and includes platform specific agent recipe


# Ensure license key is provided
if node['newrelic-infra']['license_key'].nil? || node['newrelic-infra']['license_key'].empty?
  raise 'No New Relic license key provided'
end


# Ensure platform & version is supported
case node['platform_family']
when 'debian'
  # TODO: Add better debian platform/version detection
  include_recipe 'newrelic-infra::agent_linux'
when 'rhel'
  case node['platform']
  when 'centos', 'redhat'
    case node['platform_version']
    when /^6/, /^7/
      include_recipe 'newrelic-infra::agent_linux'
    else
      raise 'The New Relic Infrastructure agent is not currently supported on this platform version'
    end
  when 'amazon'
    include_recipe 'newrelic-infra::agent_linux'
  else
    raise 'The New Relic Infrastructure agent is not currently supported on this platform'
  end
when 'windows'
  include_recipe 'newrelic-infra::agent_windows'
else
  raise 'The New Relic Infrastructure agent is not currently supported on this platform'
end
