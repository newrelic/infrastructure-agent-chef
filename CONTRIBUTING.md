# Contributing

Contributions are always welcome. Before contributing please read the
[code of conduct](./CODE_OF_CONDUCT.md) and [search the issue tracker](../../issues); your issue may have already been discussed or fixed in `main`. To contribute,
[fork](https://help.github.com/articles/fork-a-repo/) this repository, commit your changes, and [send a Pull Request](https://help.github.com/articles/using-pull-requests/).

Note that our [code of conduct](./CODE_OF_CONDUCT.md) applies to all platforms and venues related to this project; please follow it in all your interactions with the project and its participants.

## Feature Requests

Feature requests should be submitted in the [Issue tracker](../../issues), with a description of the expected behavior & use case, where they’ll remain closed until sufficient interest, [e.g. :+1: reactions](https://help.github.com/articles/about-discussions-in-issues-and-pull-requests/), has been [shown by the community](../../issues?q=label%3A%22votes+needed%22+sort%3Areactions-%2B1-desc).
Before submitting an Issue, please search for similar ones in the
[closed issues](../../issues?q=is%3Aissue+is%3Aclosed+label%3Aenhancement).

## Pull Requests

1. Ensure any install or build dependencies are removed before the end of the layer when doing a build.
2. Increase the version numbers in any examples files and the README.md to the new version that this Pull Request would represent. The versioning scheme we use is [SemVer](http://semver.org/).
3. You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you.

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
* ubuntu-18.04
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

## Contributor License Agreement

Keep in mind that when you submit your Pull Request, you'll need to sign the CLA via the click-through using CLA-Assistant. If you'd like to execute our corporate CLA, or if you have any questions, please drop us an email at opensource@newrelic.com.

For more information about CLAs, please check out Alex Russell’s excellent post,
[“Why Do I Need to Sign This?”](https://infrequently.org/2008/06/why-do-i-need-to-sign-this/).

## Slack

We host a public Slack with a dedicated channel for contributors and maintainers of open source projects hosted by New Relic.  If you are contributing to this project, you're welcome to request access to the #oss-contributors channel in the newrelicusers.slack.com workspace.  To request access, see https://newrelicusers-signup.herokuapp.com/.

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
[16]:  https://app.vagrantup.com/bento/boxes/ubuntu-18.04
[17]:  https://app.vagrantup.com/bento/boxes/centos-6.8
[18]:  https://app.vagrantup.com/bento/boxes/centos-7.2
[19]:  https://downloads.chef.io/chef-dk/
[20]:  https://github.com/chef-cookbooks/community_cookbook_tools/blob/master/delivery/project.toml
[21]:  https://www.docker.com/
[22]:  https://github.com/someara/kitchen-dokken
