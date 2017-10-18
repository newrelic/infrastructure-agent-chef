#
# Copyright (C) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

require 'spec_helper'

describe 'newrelic-infra::host_integrations' do
  shared_examples_for :default do
    let(:file_path) { '/etc/newrelic-infra/integrations.d/cassandra.yaml' }

    it 'should install the agent package' do
      expect(chef_cached).to install_package('newrelic-infra-integrations')
    end

    it 'should create the on-host integration configuration directory' do
      expect(chef_cached).to create_directory('/etc/newrelic-infra/integrations.d').with(
        owner: 'newrelic_infra',
        group: 'newrelic_infra',
        mode: '0750'
      )
    end

    it 'should create the on-host integration configuration files' do
      expect(chef_cached).to create_file(file_path).with(
        owner: 'newrelic_infra',
        group: 'newrelic_infra',
        mode: '0640',
        sensitive: true
      )
    end

    it 'should render the on-host integration configuration with any specified configuration' do
      expect(chef_cached).to(render_file(file_path).with_content do |content|
        expect(content).to match(/username: chef/)
        expect(content).to match(/password: spec/)
      end)
    end
  end

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "On #{platform}: #{version} with host integration feature enabled" do
        let(:solo) do
          ChefSpec::SoloRunner.new(platform: platform.to_s, version: version) do |node|
            node.normal['newrelic_infra']['features']['host_integrations'] = true
            node.normal['newrelic_infra']['host_integrations']['config']['cassandra']['username'] = 'chef'
            node.normal['newrelic_infra']['host_integrations']['config']['cassandra']['password'] = 'spec'
          end
        end
        let(:chef_run) do
          solo.converge(described_recipe) do
            solo.resource_collection.insert(
              PoiseService::Resources::PoiseService::Resource.new('newrelic-infra', solo.run_context)
            )
          end
        end
        cached(:chef_cached) { chef_run }

        it_behaves_like :default
      end
    end
  end
end
