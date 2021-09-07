#
# Copyright:: (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

require 'spec_helper'

describe 'newrelic-infra::host_integrations' do
  shared_examples_for :default_create do
    let(:service_account) { 'newrelic_infra' }

    it 'installs the New Relic Infrastructure custom integration' do
      expect(chef_cached).to create_newrelic_infra_integration('test_integration').with(
        integration_name: 'com.test.integration',
        remote_url: 'https://url-to-a-tarball-for-install.com/test.tar.gz'
      )
    end

    %w(
      /opt/newrelic-infra
      /opt/newrelic-infra/test_integration
    ).each do |dir|
      it 'creates the integration binary directory' do
        expect(chef_cached).to create_directory(dir).with(
          owner: service_account,
          group: service_account,
          mode: '0750'
        )
      end
    end

    it 'does not download the remote file' do
      resource = chef_cached.remote_file('/opt/newrelic-infra/test_integration/test')
      expect(resource).to do_nothing
    end

    it 'unpacks the remote tarball' do
      expect(chef_cached).to unpack_poise_archive('https://url-to-a-tarball-for-install.com/test.tar.gz').with(
        destination: '/opt/newrelic-infra/test_integration',
        keep_existing: true
      )
    end

    %w(
      definition_file
      config_file
    ).each do |file_to_create|
      it "creates the integration #{file_to_create}" do
        expect(chef_cached).to create_file(file_to_create).with(
          owner: service_account,
          group: service_account,
          mode: '0640',
          sensitive: true
        )
      end
    end

    it 'updates the binary file with the correct permissions' do
      expect(chef_cached).to create_file('/opt/newrelic-infra/test_integration/test').with(
        owner: service_account,
        group: service_account,
        mode: '0750'
      )
    end

    it 'renders the integration definition file with the correct configuration' do
      expect(chef_cached).to(render_file('definition_file').with_content do |content|
        expect(content).to match(/name: com.test.integration/)
        expect(content).to match(/description: A test custom integration/)
        expect(content).to match(/protocol_version: 1/)
        expect(content).to match(/os: linux/)
        expect(content).to match(/interval: 10/)
        expect(content).to match(/commands:/)
        expect(content).to match(/\s{2}metrics:/)
        expect(content).to match(/\s{4}command:/)
        expect(content).to match(%r{\s{6}- /opt/newrelic-infra/test_integration/test})
        expect(content).to match(/\s{6}- --metrics/)
      end)
    end

    it 'renders the configuration file with the correct configuration' do
      expect(chef_cached).to(render_file('config_file').with_content do |content|
        expect(content).to match(/integration_name: com.test.integration/)
        expect(content).to match(/instances:/)
        expect(content).to match(/\s{2}- name: test_integration_metrics/)
        expect(content).to match(/\s{4}command: metrics/)
        expect(content).to match(/\s{4}arguments:/)
        expect(content).to match(/\s{6}test: true/)
        expect(content).to match(/\s{4}labels:/)
        expect(content).to match(/\s{6}environment: test/)
      end)
    end
  end

  shared_examples_for :default_remove do
    %w(
      /opt/newrelic-infra/test_integration/test
      /var/db/newrelic-infra/custom-integrations/test_integration.yaml
      /etc/newrelic-infra/integrations.d/test_integration.yaml
    ).each do |file_to_delete|
      it "deletes the file #{file_to_delete}" do
        expect(chef_cached).to delete_file(file_to_delete)
      end
    end
  end

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "On #{platform}: #{version} with custom integration attributes" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform.to_s, version: version, step_into: ['newrelic_infra_integration']) do |node|
            node.normal['newrelic_infra']['custom_integrations']['test_integration'] = {
              action: %i(create remove),
              integration_name: 'com.test.integration',
              description: 'A test custom integration',
              remote_url: 'https://url-to-a-tarball-for-install.com/test.tar.gz',
              instances: [
                {
                  name: 'test_integration_metrics',
                  command: 'metrics',
                  arguments: {
                    test: true,
                  },
                  labels: {
                    environment: 'test',
                  },
                },
              ],
              commands: {
                metrics: %w(--metrics),
              },
            }
          end.converge(described_recipe)
        end
        cached(:chef_cached) { chef_run }

        it_behaves_like :default_create
        it_behaves_like :default_remove
      end
    end
  end
end
