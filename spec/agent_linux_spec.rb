#
# Copyright (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

require 'spec_helper'

describe 'newrelic-infra::agent_linux' do
  shared_examples_for :default do
    let(:service_user) { 'newrelic_infra' }

    it 'should create the service account `newrelic_infra`' do
      expect(chef_cached).to create_poise_service_user(service_user).with(
        group: service_user
      )
    end

    it 'should create the agent configuration directory' do
      expect(chef_cached).to create_directory('/etc/newrelic-infra').with(
        owner: service_user,
        group: service_user,
        mode: '0750'
      )
    end

    it 'should create the agent configuration file' do
      expect(chef_cached).to create_file('/etc/newrelic-infra/agent.yaml').with(
        owner: service_user,
        group: service_user,
        mode: '0640',
        sensitive: true
      )
    end

    it 'configuration file generation notifies agent to restart' do
      file_resource = chef_cached.file('/etc/newrelic-infra/agent.yaml')
      expect(file_resource).to notify('poise_service[newrelic-infra]').to(:restart).delayed
    end

    it 'should create add the package repo' do
      resource_type =
        case chef_cached.node['platform_family']
        when 'debian'
          :apt_repository
        when 'rhel', 'amazon'
          :yum_repository
        end
      expect(chef_cached).to ChefSpec::Matchers::ResourceMatcher.new(resource_type, :add, 'newrelic-infra')
    end

    it 'should create the repo cache for YUM repos' do
      next unless %w(rhel amazon).include? chef_cached.node['platform_family']
      expect(chef_cached).to makecache_yum_repository('newrelic-infra')
    end

    it 'should install the agent package' do
      expect(chef_cached).to install_package('newrelic-infra').with(action: [:install],
                                                                    retries: 3,
                                                                    version: '')
    end

    it 'should enable the agent service' do
      expect(chef_cached).to enable_poise_service('newrelic-infra').with(
        command: '/usr/bin/newrelic-infra -config=/etc/newrelic-infra/agent.yaml'
      )
    end

    it 'should include the host integrations recipe' do
      expect(chef_cached).to include_recipe('newrelic-infra::host_integrations')
    end
  end

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "On #{platform}: #{version} with default attributes" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform.to_s,
                                   version: version) do |node|
                                     node.normal['newrelic_infra']['packages']['agent']['retries'] = 3
                                   end.converge(described_recipe)
        end
        cached(:chef_cached) { chef_run }

        it_behaves_like :default
      end
    end
  end
end
