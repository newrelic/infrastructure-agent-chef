# newrelic-infra Cookbook

This cookbook installs and configures the New Relic Infrastructure agent.

## Requirements

### Platforms

- RHEL
  - Red Hat 7
  - Red Hat 6
  - Oracle 7
  - Oracle 6
  - CentOS 7
  - CentOS 6
  - Amazon Linux (all versions)
- Ubuntu
  - 16 Xenial
  - 14 Trusty
  - 12 Precise
- Debian
  - 10 Buster
  - 9 Stretch
  - 8 Jessie
  - 7 Wheezy
- Windows
  - Windows 2012 R2
  
### Chef

- Chef 12+

### Cookbooks

- none

## Recipes

### default
Include the default recipe to install and configure the New Relic Infrastructure agent.

### agent
The `agent` recipe will validate required attributes and do basic platform detection to decide which platform specific recipe to include.

### agent_linux
The `agent_linux` recipe:

1. Adds the `newrelic-infra` package repository source
1. Installs|upgrades|removes `newrelic-infra` package
1. Sets up the `newrelic-infra` agent service
1. Sets the `newrelic-infra.yml` config file

### agent_windows
- `node['newrelic-infra']['windows_source']` - allows you to pull your Windows agent from arbitrary URLs. You can 'pin' a version via attributes if you need (defaults to latest)
- `node['newrelic-infra']['windows_checksum']` - will check the checksum of your Windows agent (defaults to nil). Recommended to insert via attributes similar to `windows_source`

## Attributes

See `attributes/defaults.rb` for default values.

- `node['newrelic-infra']['license_key']` - Your New Relic license key.
- `node['newrelic-infra']['log_file']` - Override system log file location by providing Log path and file name.
- `node['newrelic-infra']['verbose']` - Log verbosity setting. Type: String
- `node['newrelic-infra']['proxy']` - Your proxy url if required.
- `node['newrelic-infra']['agent_action']` - `newrelic-infra` package actions. Values:
  - `'install'`: _(Default)_ Installs package. If `'agent_version'` is specified, installs specific version.
  - `'upgrade'`: Installs package and/or ensures it's the latest version.
  - `'remove'`:  Removes the package.
- `node['newrelic-infra']['agent_version']` - Specify `newrelic-infra` package version to pin.
- `node['newrelic-infra']['custom_attributes']` - Specify custom attributes as key/value pairs.

## Usage

1. Add the `newrelic-infra` cookbook dependency to your `metadata.rb` or `Berksfile`
1. Set `node['newrelic-infra']['license_key']` attribute with your New Relic license key
1. Include `default` recipe or add it to your run list

Copyright (c) 2017 New Relic, Inc. All rights reserved.
