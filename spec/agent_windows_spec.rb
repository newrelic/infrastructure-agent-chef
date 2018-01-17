#
# Copyright (c) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

require 'spec_helper'

describe 'newrelic-infra::agent_windows' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2016') do |node|
      node.normal['newrelic_infra']['packages']['agent']['retries'] = 3
    end.converge(described_recipe)
  end

  it 'converges' do
    expect { chef_run }.to_not raise_error
  end

  it 'installs the agent package' do
    expect(chef_run).to install_windows_package('newrelic-infra').with(action: [:install],
                                                                       retries: 3,
                                                                       version: nil)
  end
end
