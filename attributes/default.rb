# default to installing the latest version, but don't auto upgrade moving forward
# change action to 'upgrade' to automatically fetch the latest version of the agent
# change version to a particular version to pin the agent to a particular version
default['newrelic-infra']['agent_action'] = 'install'
default['newrelic-infra']['agent_version'] = nil

default['newrelic-infra']['license_key'] = nil
