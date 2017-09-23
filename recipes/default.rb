#
# Copyright (C) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

# Install and configure the New Relic Infrastructure agent
if platform?('windows')
  include_recipe 'newrelic-infra::agent_windows'
else
  include_recipe 'newrelic-infra::agent_linux'
end
