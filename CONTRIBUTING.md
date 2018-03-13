# Contributing

Contributions are more than welcome.
Bug reports with specific reproduction steps are great.
If you have a code contribution you'd like to make, open a pull request with suggested code.

Note that PR's and issues are reviewed every ~2 weeks.
If your PR or issue is critical in nature, please reflect that in the description so that it receives faster attention.

Parts of this documentation have been adopted from the [Chef community cookbook documentation][8].

## Pull requests

* Clearly state their intent in the title
* Have a description that explains the need for the changes
* Include tests! (Make sure the recipe works and converges)
* Don't break the public API
* Add yourself to the CONTRIBUTING file at the bottom
* Increment the recipe version info in metadata.rb
* Test some more!

By contributing to this project you agree that you are granting New Relic a non-exclusive, non-revokable, no-cost license to use the code, algorithms, patents, and ideas in that code in our products if we so choose. You also agree the code is provided as-is and you provide no warranties as to its fitness or correctness for any purpose.

## Testing

### Installing dependencies

A working [ChefDK][19] installation set as your system's default ruby or configured as appropriate for use with a Ruby environment manager like rvm or rbenv.

Hashicorp's [Vagrant][12] and [Oracle's Virtualbox][13] for integration testing.

Install dependencies:

```sh
chef exec bundle install
```

Update any installed dependencies to the latest versions:

```sh
chef exec bundle update
```

### Running tests

To remain consistent with Chef managed community cookbooks, we use the Delivery CLI tool that utilizes their [Delivery project.toml file][20].
Testing will stop if any given test stage fails.
Explanations of each stage and instructions on how to individually run each stage can be found below.

Run all tests:

```sh
delivery local all
```

#### Lint stage

The lint stage runs Ruby specific code linting using [cookstyle][5].
[Cookstyle][5] offers a tailored [RuboCop][3] configuration enabling / disabling rules to better meet the needs of cookbook authors.
Cookstyle ensures that projects with multiple authors have consistent code styling.

Run lint stage:

```sh
delivery local lint
```

#### Syntax stage

The syntax stage runs Chef cookbook specific linting and syntax checks with [Foodcritic][4].
Specific [Foodcritic][4] configuration can be seen in [.foodcritic][6].

Run syntax stage:

```sh
delivery local syntax
```

#### Unit tests

Unit tests are run with [ChefSpec][7]. ChefSpec is an extension of Rspec, specially formulated for testing Chef cookbooks.
Chefspec compiles your cookbook code and converges the run in memory, without actually executing the changes.
The user can write various assertions based on what they expect to have happened during the Chef run.
Chefspec is very fast and useful for testing complex logic as you can easily converge a cookbook many times in different ways.
Platforms are pulled from [Fauxhai][14].

Platforms tested:

* redhat-7.3
* redhat-6.8
* oracle-7.2
* oracle-6.8
* centos-7.4.1708
* centos-6.9
* amazon-2017.03
* amazon-2013.09
* debian-9.1
* debian-8.9
* debian-7.11
* ubuntu-16.04
* ubuntu-14.04

Run unit tests:

```sh
delivery local unit
```

#### Integration tests

Integration testing is performed by [Test Kitchen][9]. Integration tests can be performed on a local workstation using [Vagrant][12] and [VirtualBox][13].
After a successful converge, tests are uploaded and run out of band of Chef.
Tests should be designed to ensure that a recipe has accomplished its respective goal(s).
All integration tests have been written using [Inspec][10].
See [.kitchen.yaml][11] for more information on the specific configuration.

To run tests using [Docker][21] and [kitchen-docken][22] set the `KITCHEN_LOCAL_YAML` environment variable to `.kitchen.dokken.yml`.

Platforms tested:

* [ubuntu-12.04][15]
* [ubuntu-14.04][16]
* [centos-6.8][17]
* [centos-7.2][18]

Run integration tests:

```sh
chef exec kitchen test
```

To see a list of available test instances run:

```sh
chef exec kitchen list
```

To test specific instance run:

```sh
chef exec kitchen test INSTANCE_NAME
```

## Releasing new versions

Tags in GitHub will create a new release on Supermarket automatically via Travis CI.

To create a release:

* Have current master have an updated changelog and a version in metadata.rb
  newer than the latest version at https://supermarket.chef.io/cookbooks/newrelic-infra
* Tag a new version: `git tag -a X.Y.Z -m "$CHANGELOG_ENTRY_FOR_NEW_VERSION" && git push --tags`
* Watch the build with the version number in Travis: 
  https://travis-ci.org/newrelic/infrastructure-agent-chef/builds
* If that passes, the new version should be on
  https://supermarket.chef.io/cookbooks/newrelic-infra and available to
  use everywhere

## Contributors

* David Lanner (@dlanner)
* Don O'Neill <don.oneill @ apexlearning.com>
* Robert Hak <robert.hak @ iacapps.com>
* Jordan Faust (jfaust47@gmail.com)
* Brandon Sharitt (brandon@sharitt.com)
* Nathan Smith (nsmith@newrelic.com)
* Mark Whelan (mbwhelan@gmail.com)
* [Trevor Wood][1] ([trevor.g.wood@gmail.com][2])
* Codarren Velvindron (codarren@hackers.mu)
* Ruben Hervas (@xino12)

Copyright (c) 2016-2017 New Relic, Inc. All rights reserved.

[1]:  https://github.com/taharah
[2]:  mailto:trevor.g.wood@gmail.com
[3]:  https://github.com/bbatsov/rubocop
[4]:  https://github.com/foodcritic/foodcritic
[5]:  https://github.com/chef/cookstyle
[6]:  .foodcritic
[7]:  https://github.com/chefspec/chefspec
[8]:  https://github.com/chef-cookbooks/community_cookbook_documentation
[9]:  https://github.com/test-kitchen/test-kitchen
[10]:  https://www.inspec.io/
[11]:  .kitchen.yml
[12]:  https://www.vagrantup.com/
[13]:  https://www.virtualbox.org/
[14]:  https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
[15]:  https://app.vagrantup.com/bento/boxes/ubuntu-12.04
[16]:  https://app.vagrantup.com/bento/boxes/ubuntu-14.04
[17]:  https://app.vagrantup.com/bento/boxes/centos-6.8
[18]:  https://app.vagrantup.com/bento/boxes/centos-7.2
[19]:  https://downloads.chef.io/chef-dk/
[20]:  https://github.com/chef-cookbooks/community_cookbook_tools/blob/master/delivery/project.toml
[21]:  https://www.docker.com/
[22]:  https://github.com/someara/kitchen-dokken
