#
# Copyright:: (C) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

describe user('newrelic_infra') do
  it { should exist }
  its('group') { should eq 'newrelic_infra' }
  its('home') { should eq '/home/newrelic_infra' }
  its('shell') { should eq '/bin/false' }
end

describe group('newrelic_infra') do
  it { should exist }
end

if os[:family] == 'debian'
  apt('https://download.newrelic.com/infrastructure_agent/linux/apt') do
    it { should exist }
    it { should be_enabled }
  end
elsif os[:family] == 'redhat'
  describe yum.repo('newrelic-infra') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include("https://download.newrelic.com/infrastructure_agent/linux/yum/el/#{os[:release][0]}") }
  end
end

describe package('newrelic-infra') do
  it { should be_installed }
end

describe file('/etc/newrelic-infra') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/etc/newrelic-infra.yml') do
  it { should be_file }
  it { should be_owned_by 'newrelic_infra' }
  it { should be_grouped_into 'newrelic_infra' }
  its('mode') { should cmp '0640' }
  its('content') { should match(/license_key: abcd/) }
  its('content') { should match(/verbose: 0/) }
end

# `poise_service` uses upstart for RHEL systems less than 7;
# however, Inspec uses `sysvinit`, so we need to.override
# the default autodetected service type for these systems.
newrelic_service = os[:family] == 'redhat' && os[:release].to_i < 7 ? upstart_service('newrelic-infra') : service('newrelic-infra')

describe newrelic_service do
  it { should be_enabled }
  it { should be_installed }
  it { should be_running }
end
