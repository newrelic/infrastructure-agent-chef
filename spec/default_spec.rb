#
# Copyright (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

require 'spec_helper'

describe 'newrelic-infra::default' do
  shared_examples_for :default do
    it 'should include the Linux install recipe' do
      expect(chef_cached).to include_recipe('newrelic-infra::agent_linux')
    end
  end

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "On #{platform}: #{version} with default attributes" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform.to_s,
                                   version: version).converge(described_recipe)
        end
        cached(:chef_cached) { chef_run }

        it_behaves_like :default
      end
    end
  end
end
