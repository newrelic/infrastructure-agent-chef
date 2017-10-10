#
# Copyright (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

require 'spec_helper'

describe 'newrelic-infra::agent_windows' do
  shared_examples_for :default do
    it 'should fail when ran on an unsupported platform' do
      expect { chef_cached }.to raise_error
    end
  end

  unsupported_platforms.each do |platform, versions|
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
