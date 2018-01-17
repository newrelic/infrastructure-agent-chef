# newrelic-infra Cookbook CHANGELOG

This file is used to list changes made in each version of the `newrelic-infra` cookbook.

## 0.5.0 (2018-01-17)

FEATURES:

* Add `retries` attribute for packages

## 0.4.0 (2017-11-12)

FEATURES:

* Windows support

## 0.3.3 (2017-11-06)

BUG FIXES:

* Travis deploy was not honoring the chefignore file

## 0.3.2 (2017-11-06)

IMPROVEMENTS:

* Cookbook is automatically deployed to [Chef Supermarket](https://supermarket.chef.io/cookbooks/newrelic-infra)

## 0.3.1 (2017-10-23)

IMPROVEMENTS:

* Add .kitchen.dokken.yml to allow Test Kitchen tests in Docker
* Add .travis.yml to run tests in Travis CI
* Typo fixes
* Change "LWRP" to "custom resource" in documentation
* Automatically deploy with Travis CI to supermarket

## 0.3.0 (2017-10-18)

BREAKING CHANGES:

* The minimum supported Chef version is now 12.15+ instead of 12.14+.
* The prefix name for custom on-host integrations has been changed to use the name of the Chef resource instead of the integration name since the New Relic Infrastructure API does not accept prefix names with `.`'s.

FEATURES:

* Add `sensitive` to all configuration file resources as well as associated unit testing for the `sensitive` property.

BUG FIXES:

* Remove the use of `Hash#compact`, which only works with Ruby >= 2.4. No versions of Chef 12.x ship with a version of Ruby this new. Replace with monkey patched method `Hash.delete_blank` ([#18](https://github.com/newrelic/infrastructure-agent-chef/issues/18)).
* Modify the generated YAML configuration files to generate a format that is compatible with the Infrastructure agent's Go YAML parser ([#19](https://github.com/newrelic/infrastructure-agent-chef/issues/19)).

## 0.2.0 (2017-10-16)

FEATURES:

* Add `sensitive` to agent configuration file resource

## 0.1.0 (2017-10-12)

NOTE: Versions prior to 0.1.0 were not tagged or released on the [Chef supermarket](https://supermarket.chef.io).

BREAKING CHANGES:

* *Attribute namespace changed:* The top-level attribute key was changed from `newrelic-infra` to `newrelic_infra` in order to be used as both strings and symbols.
* Only `chef-client` versions `>= 12.14` are supported.
* Lots of attribute changes to help simplify configuration generation. See [README.md](README.md) for more details.

FEATURES:

* **Testing added:** Unit and integration tests added. See the [CONTRIBUTING][3] guide for more details.
* **newrelic\_infra\_integration LWRP added:** An LWRP for installing and configuring custom New Relic Infrastructure on-host integrations. Custom integrations can also be installed using by including the default recipe and the appropriate attributes.
* **New Relic On-Host integrations:** Added the capability to install and configure the New Relic provided on-host integrations. See the [README.md](README.md) for more details on what attributes to set.

IMPROVEMENTS:

* Updated the apt and YUM repository resources to use metaprogramming. This allows all properties available for each of the respective resources to be available as attributes.
* Resolved all Rubocop and Foodcritic violations.
