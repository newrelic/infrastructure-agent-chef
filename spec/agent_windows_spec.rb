#
# Copyright (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

require 'spec_helper'

describe 'newrelic-infra::agent_windows' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2016').converge(described_recipe)
  end

  it 'converges' do
    expect { chef_run }.to_not raise_error
  end
end
