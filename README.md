[![Community Project header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Community_Project.png)](https://opensource.newrelic.com/oss-category/#community-project)

# Chef cookbook for the New Relic infrastructure agent [![Travis CI Build Status](https://travis-ci.org/newrelic/infrastructure-agent-chef.svg?branch=master)](https://travis-ci.org/newrelic/infrastructure-agent-chef) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/newrelic/infrastructure-agent-chef?svg=true)](https://ci.appveyor.com/project/smith37586/infrastructure-agent-chef) [![Chef Supermarket Cookbook](https://img.shields.io/cookbook/v/newrelic-infra.svg)](https://supermarket.chef.io/cookbooks/newrelic-infra)

This cookbook installs and configures the New Relic infrastructure agent, as well New Relic and and [on-host integrations](https://docs.newrelic.com/docs/integrations/host-integrations/host-integrations-list/).

## Install and use the Chef cookbook
some change
### Requirements

#### Platforms

* Amazon Linux all versions
* CentOS version 5 or higher
* Debian version 7 ("Wheezy") or higher
* Red Hat Enterprise Linux (RHEL) version 5 or higher
* Ubuntu versions 16.04.*, 18.04.*, 20.04* (LTS versions)
* Windows Server 2008, 2012, 2016, and 2019, and their service packs.
* SUSE Linux Enterprise 11, 12

#### Chef

- Chef 15+

### Recipes

#### `newrelic-infra::default`

Determines the platform and includes the appropriate platform specific recipe. This is the only recipe that should be included in a node's run list.

#### `newrelic-infra::agent_linux`

Installs and configures the Infrastructure agent on a Linux host. This recipe should _NOT_ be directly included in a node's run list. The default recipe will automatically determine which platform specific recipe to apply.

Here are the steps that the recipe performs:

1. Adds the `newrelic-infra` package repository source.
2. Can install, upgrade, or remove the `newrelic-infra` package. By default, the package is only installed.
3. Enables and starts the `newrelic_infra` agent service.
4. Generates the agent configuration file.
5. Includes the `newrelic-infra::host_integrations` recipe to install and configure any on-host integrations.

#### `newrelic-infra::agent_windows`

Installs and configures the Infrastructure agent on a Windows host. This recipe should _NOT_ be directly included in a node's run list. The default recipe will automatically determine which platform specific recipe to apply.

#### `newrelic-infra::host_integrations`

Installs New Relic provided and on-host integrations if the integration has been addded to the list of `host_integrations` (for example, `default['newrelic_infra']['features]['host_integrations'] = []`). It also generates configuration for any of the available on-host integrations from New Relic, and installs any custom integrations defined with attributes.

For more infromation on the available custom resource for installing and configuring custom on-host integrations see the [Custom resources][9] documentation.

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

For more information on the available New Relic on-host integrations and configuration you can check the [official documentation][6].

### Attributes

See [attributes/defaults.rb][3] for more details and default values.

| Name | Default value | Description |
|:-----|:--------------|:------------|
| `default['newrelic_infra']['features']['host_integrations']` | `[]` | List of New Relic on-host integrations |
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
| `default['newrelic_infra']['packages']['agent']['retries']` | `0` | The number of times to catch exceptions and retry the resource |
| `default['newrelic_infra']['packages']['agent']['version']` | `nil` | Version of the agent package to install |
| `default['newrelic_infra']['packages'][integration_package_name]['action']` | `[:install]` | Action(s) to perform on the agent on-host integration package |
| `default['newrelic_infra']['packages'][integration_package_name]['retries']` | `0` | The number of times to catch exceptions and retry the resource |
| `default['newrelic_infra']['packages'][integration_package_name]['version']` | `nil` | Version of the on-host integration package to install |
| `default['newrelic_infra']['host_integrations']['config_dir']` | `/etc/newrelic-infra/integrations.d` | Directory for the New Relic provided on-host integration configurations |
| `default['newrelic_infra']['host_integrations']['config']` | `{}` | New Relic provided on-host integration configuration |
| `default['newrelic_infra']['custom_integrations']` | `{}` | New Relic Infrastructure on-host custom integration configuration |
| `default['newrelic_infra']['provider']` | `package_manager` | When `package_manager` installs the packages from yum/apt/zypp, if `tarball` installs the agent from a tarball |
| `default['newrelic_infra']['tarball']['version']` | `nil` | the version number of the tarball to install |
| `default['newrelic_infra']['delete_yaml_quotes']` | `true` | if true it deletes the quotes (`"`) from the generated integration configs and definitions files |

#### APT repository attributes

The `apt_repository` Chef resource is built using metaprogramming, so that the configuration can be extended via attributes. Any property available to the resource can be passed in via attributes.

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

#### Windows attributes

When using Windows, you can set a source URL and checksum for the agent download.

| Name | Default value | Description |
|:-----|:--------------|:------------|
| `default['newrelic-infra']['windows_source']` | `https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.msi` | Remote URL for Infrastructure agent windows download |
| `default['newrelic-infra']['windows_checksum']` | `nil` | SHA-256 Checksum for source file |

#### Yum repository attributes

The `yum_repository` Chef resource is built using metaprogramming, so that the configuration can be extended via attributes. Any property available to the resource can be passed in via attributes.

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

### Custom Resources

#### `newrelic_infra_integration`

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

### Usage

#### Cookbook usage

- Set any attributes necessary for your desired configuration
- Add the `newrelic-infra::default` recipe your run list
- For wrapper cookbooks, add the `newrelic-infra` cookbook as a dependency to your `metadata.rb` or `Berksfile`, then include `newrelic-infra::default` recipe.

#### Custom resource usage

- Add the `newrelic-infra` cookbook as a dependency to your `metadata.rb` or `Berksfile`
- Configure the custom resource(s) using the supported properties

### Testing

Refer to
https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/TESTING.MD

### Releasing new versions

For releasing a new version to the [Chef Supermarket][12] follow this steps:

- Update the version number in [metadata.rb][13].
- Create the github release for the new version. This will trigger a 
  GitHub Actions job that will deploy the new version.
- Watch the build with the version number in Github Actions: 
  https://github.com/newrelic/infrastructure-agent-chef/actions
- If that passes, the new version should be on
  https://supermarket.chef.io/cookbooks/newrelic-infra and available to
  use everywhere

## Support

Should you need assistance with New Relic products, you are in good hands with several support diagnostic tools and support channels.

>New Relic offers NRDiag, [a client-side diagnostic utility](https://docs.newrelic.com/docs/using-new-relic/cross-product-functions/troubleshooting/new-relic-diagnostics) that automatically detects common problems with New Relic agents. If NRDiag detects a problem, it suggests troubleshooting steps. NRDiag can also automatically attach troubleshooting data to a New Relic Support ticket. Remove this section if it doesn't apply.

If the issue has been confirmed as a bug or is a feature request, file a GitHub issue.

**Support Channels**

* [New Relic Documentation](https://docs.newrelic.com): Comprehensive guidance for using our platform
* [New Relic Community](https://discuss.newrelic.com/c/support-products-agents/new-relic-infrastructure): The best place to engage in troubleshooting questions
* [New Relic Developer](https://developer.newrelic.com/): Resources for building a custom observability applications
* [New Relic University](https://learn.newrelic.com/): A range of online training for New Relic users of every level
* [New Relic Technical Support](https://support.newrelic.com/) 24/7/365 ticketed support. Read more about our [Technical Support Offerings](https://docs.newrelic.com/docs/licenses/license-information/general-usage-licenses/support-plan).

## Privacy

At New Relic we take your privacy and the security of your information seriously, and are committed to protecting your information. We must emphasize the importance of not sharing personal data in public forums, and ask all users to scrub logs and diagnostic information for sensitive information, whether personal, proprietary, or otherwise.

We define “Personal Data” as any information relating to an identified or identifiable individual, including, for example, your name, phone number, post code or zip code, Device ID, IP address, and email address.

For more information, review [New Relic’s General Data Privacy Notice](https://newrelic.com/termsandconditions/privacy).

## Contribute

We encourage your contributions to improve this project! Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.

If you have any questions, or to execute our corporate CLA (which is required if your contribution is on behalf of a company), drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

If you would like to contribute to this project, review [these guidelines](./CONTRIBUTING.md).

To all contributors, we thank you!  Without your contribution, this project would not be what it is today.

## License

infrastructure-agent-chef is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.

[1]:  attributes/default.rb
[2]:  https://docs.chef.io/resource_apt_repository.html
[3]:  https://docs.chef.io/resource_yum_repository.html
[4]:  https://docs.newrelic.com/docs/integrations/host-integrations/host-integrations-list
[5]:  #custom-resources
[6]: CONTRIBUTING.md
[7]: CHANGELOG.md
[8]: https://supermarket.chef.io/cookbooks/newrelic-infra
[9]: metadata.rb#L10
[10]: https://travis-ci.org/newrelic/infrastructure-agent-chef
