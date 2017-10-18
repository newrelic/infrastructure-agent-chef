# newrelic-infra Cookbook

This cookbook installs and configures the New Relic Infrastructure agent as well as new Relic provided and custom on-host integrations for the Infrastructure agent can be installed.
See the [CHANGELOG][11] for information on the latest changes.

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

### Chef

- Chef 12.15+

### Cookbooks

- [poise-service][1]
- [poise-archive][2]

## Recipes

### `newrelic-infra::default`

Determines the platform and includes the appropriate platform specific recipe.
This is the only recipe that should be included in a node's run list.

### `newrelic-infra::agent_linux`

Installs and configures the Infrastructure agent on a Linux host.
This recipe should _NOT_ be directly included in a node's run list.
The default recipe will automatically determine which platform specific recipe to apply.

1. Adds the `newrelic-infra` package repository source
2. Can install, upgrade, or remove the `newrelic-infra` package. By default, the package is only installed.
3. Enables and starts the `newrelic_infra` agent service
4. Generates the agent configuration file
5. Includes the `newrelic-infra::host_integrations` recipe to install and configure any on-host integrations

### `newrelic-infra::agent_windows`

Installs and configures the Infrastructure agent on a Windows host.
This recipe should _NOT_ be directly included in a node's run list.
The default recipe will automatically determine which platform specific recipe to apply.
Currently, Windows host configuration is _NOT_ supported by this cookbook.
An error will be raised and fail the `chef-client` run for any detected Windows nodes.

### `newrelic-infra::host_integrations`

Installs New Relic provided and custom on-host integrations if the associated feature flag is enabled (i.e., `default['newrelic_infra']['features]['host_integrations']`).
Generates configuration for any of the available on-host integrations from New Relic.
Installs any custom integrations defined with attributes.
For more infromation on the available LWRP for installing and configuring custom on-host integrations see the [LWRPs][9] documentation.

Example configuration for a custom on-host integration installed and configured via attributes:

```ruby
default['newrelic_infra']['custom_integrations']['test_integration'] = {
  integration_name: 'com.test.integration',
  remote_url: 'https://url-to-a-tarball-for-install.com/test.tar.gz',
  instances: [
    {
      name: 'test_integration_metrics',
      command: 'metrics',
      arguments: {
        test: true
      },
      labels: {
        environment: 'test'
      }
    }
  ],
  commands: {
    metrics: %w[--metrics]
  }
}
```

For more information on the available New Relic on-host integrations and configuration see:

1. [Cassandra][6]
2. [MySQL][7]
3. [Nginx][8]

## Attributes

See [attributes/defaults.rb][3] for more details and default values.

| Name | Default value | Description |
|:-----|:--------------|:------------|
| `default['newrelic_infra']['features']['manage_service_account']` | `true` | Manage a local service account for running the agent |
| `default['newrelic_infra']['features']['host_integrations']` | `false` | Install New Relic on-host integrations |
| `default['newrelic_infra']['user']['name']` | `newrelic_infra` | Service account user name |
| `default['newrelic_infra']['group']['name']` | `newrelic_infra` | Service account group name |
| `default['newrelic_infra']['config']['license_key']` | `nil` | Account license key to send metrics to |
| `default['newrelic_infra']['config']['display_name']` | `nil` | Override the auto-generated hostname for reporting |
| `default['newrelic_infra']['config']['proxy']` | `nil` | Use a proxy to communicate with New Relic |
| `default['newrelic_infra']['config']['verbose']` | `nil` | When set to 1, enables verbose logging for the agent |
| `default['newrelic_infra']['config']['debug']` | `nil` | Enable Golang debugging |
| `default['newrelic_infra']['config']['log_file']` | `nil` | To log to another location; when not set, the agent logs to the system log files |
| `default['newrelic_infra']['config']['custom_attributes']` | `{}` | A hash of custom attributes to annotate the data from this agent instance |
| `default['newrelic_infra']['agent']['config']['file']` | `agent.yaml` | File name for the agent configuration |
| `default['newrelic_infra']['agent']['config']['mode']` | `0640` | File permissions for the agent configuration |
| `default['newrelic_infra']['agent']['directory']['path']` | `/etc/newrelic-infra` | Directory path for the agent configuration |
| `default['newrelic_infra']['agent']['directory']['mode']` | `0750` | Directory permissions for the agent configuration |
| `default['newrelic_infra']['packages']['agent']['action']` | `[:install]` | Action(s) to perform on the agent package |
| `default['newrelic_infra']['packages']['agent']['version']` | `nil` | Verion of the agent package to install |
| `default['newrelic_infra']['packages']['host_integrations']['action']` | `[:install]` | Action(s) to perform on the agent on-host integrations package |
| `default['newrelic_infra']['packages']['host_integrations']['version']` | `nil` | Verion of the on-host integrations package to install |
| `default['newrelic_infra']['host_integrations']['config_dir']` | `/etc/newrelic-infra/integrations.d` | Directory for the New Relic provided on-host integration configurations |
| `default['newrelic_infra']['host_integrations']['config']` | `{}` | New Relic provided on-host integration configuration |
| `default['newrelic_infra']['custom_integrations']` | `{}` | New Relic Infrastructure on-host custom integration configuration |

### apt repository attributes

The `apt_repository` Chef resource is built using metaprogramming, so that the configuration can be extended via attributes.
Any property available to the resource can be passed in via attributes.
Attributes that cannot be passed to the resource are logged out as warnings in order to prevent potential failes from typos, older Chef versions, etc.
For more information, refer to the Chef documentation on the [apt_repository][4] resource.

| Name | Default value | Description |
|:-----|:--------------|:------------|
| `default['newrelic_infra']['apt']['uri']` | `https://download.newrelic.com/infrastructure_agent/linux/apt` | Repository base URL |
| `default['newrelic_infra']['apt']['key']` | `https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg` | Repository GPG key URL |
| `default['newrelic_infra']['apt']['distribution']` | `node['lsb']['codename']` | Distribution code name |
| `default['newrelic_infra']['apt']['components']` | `['main']` | Repository components |
| `default['newrelic_infra']['apt']['arch']` | `'amd64'` | Package architecture to install |
| `default['newrelic_infra']['apt']['action']` | `[:add]` | `apt_repository` resource actions to perform |

### YUM repository attributes

The `yum_repository` Chef resource is built using metaprogramming, so that the configuration can be extended via attributes.
Any property available to the resource can be passed in via attributes.
Attributes that cannot be passed to the resource are logged out as warnings in order to prevent potential failes from typos, older Chef versions, etc.
For more information, refer to the Chef documentation on the [yum_repository][5] resource.

| Name | Default value | Description |
|:-----|:--------------|:------------|
| `default['newrelic_infra']['yum']['description']` | 'New Relic Infrastructure' | Repository description |
| `default['newrelic_infra']['yum']['baseurl']` | Default is determined by distribution see [attributes/default.rb][3] for more information. | Repository base URL |
| `default['newrelic_infra']['yum']['gpgkey']` | `'https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg'` | Repository GPG key URL |
| `default['newrelic_infra']['yum']['gpgcheck']` | `true` | Perform a GPG check on installed packages |
| `default['newrelic_infra']['yum']['repo_gpgcheck']` | `true` | Perform a GPG check on the package repository |
| `default['newrelic_infra']['yum']['action']` | `[:add, :makecache]` | `yum_repository` resource actions to perform |

## LWRPs

### `newrelic_infra_integration`

Installs and configures a custom New Relic Infrastructure on-host integration.

Example:

```ruby
newrelic_infra_integration 'test' do
  integration_name 'test_integration'
  remote_url 'https://url-to-a-tarball-for-install.com/test.tar.gz'
  commands { metrics: %w[--metrics] }
  instances(
    [
      {
        name: 'test_integration_metrics',
        command: 'metrics',
        arguments: {
          test: true
        },
        labels: {
          environment: 'test'
        }
      }
    ]
  )
end
```

Supported properties:

| Property name | Required | Type | Default |
|:--------------|:---------|:-----|:--------|
| `integration_name` | `true` | String | nil |
| `remote_url` | `true` | String | nil |
| `instances` | `true` | Array | nil |
| `commands` | `true` | Hash | nil |
| `description` | `false` | [String, nil] | nil |
| `cli_options` | `false` | [Hash, nil] | nil |
| `interval` | `false` | Integer | 10 |
| `prefix` | `false` | String | `integration/#{integration_name}` |
| `install_method` | `true` | `'tarball'` or `'binary'` | 'tarball' |
| `os` | `false` | `'linux'` | 'linux' |
| `protocol_version` | `false` | Integer | 1 |
| `user` | `false` | String | `'newrelic_infra'` |
| `group` | `false` | String | `'newrelic_infra'` |
| `base_dir` | `false` | String | `'/var/db/newrelic-infra/custom-integrations'` |
| `bin_dir` | `false` | String | `/opt/newrelic-infra` |
| `bin` | `false` | String | The folder is `#{bin_dir}/#{name}` and the file name is the tarball or binary without any extension |
| `definition_file` | `false` | String | `#{base_dir}/#{resource_name).yaml` |
| `config_dir` | `false` | String | '/etc/newrelic-infra/integrations.d/' |
| `config_file` | `false` | String | `#{config_dir}/#{resource_name).yaml` |

## Usage

### Cookbook usage

- Set any attributes necessary for your desired configuration
- Add the `newrelic-infra::default` recipe your run list
- For wrapper cookbooks, add the `newrelic-infra` cookbook as a dependency to your `metadata.rb` or `Berksfile`, then include `newrelic-infra::default` recipe.

### LWRP usage

- Add the `newrelic-infra` cookbook as a dependency to your `metadata.rb` or `Berksfile`
- Configure the LWRP(s) using the supported properties

## Testing

See [CONTRIBUTING.md][10] for details on how to test and contribute to this cookbook.

Copyright (c) 2016-2017 New Relic, Inc. All rights reserved.

[1]:  https://github.com/poise/poise-service
[2]:  https://github.com/poise/poise-archive
[3]:  attributes/default.rb
[4]:  https://docs.chef.io/resource_apt_repository.html
[5]:  https://docs.chef.io/resource_yum_repository.html
[6]:  https://docs.newrelic.com/docs/infrastructure/integrations/cassandra-integration-new-relic-infrastructure
[7]:  https://docs.newrelic.com/docs/infrastructure/integrations/mysql-integration-new-relic-infrastructure
[8]:  https://docs.newrelic.com/docs/infrastructure/integrations/nginx-integration-new-relic-infrastructure
[9]:  #lwrps
[10]:  CONTRIBUTING.md
[11]:  CHANGELOG.md