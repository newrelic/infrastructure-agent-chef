#
# Copyright (C) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

describe package('newrelic-infra-integrations') do
  it { should be_installed }
end

describe file('/etc/newrelic-infra/integrations.d/cassandra.yaml') do
  it { should be_file }
  it { should be_owned_by 'newrelic_infra' }
  it { should be_grouped_into 'newrelic_infra' }
  its('mode') { should cmp '0640' }
  its('content') { should match(/username: test/) }
  its('content') { should match(/password: kitchen/) }
end
