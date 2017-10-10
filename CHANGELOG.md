# newrelic-infra Cookbook CHANGELOG

This file is used to list changes made in each version of the `newrelic-infra` cookbook.

## v0.1.0 (UNRELEASED)

NOTE: Versions prior to 0.1.0 were not tagged or released on the [Chef supermarket][1].

BREAKING CHANGES:

* *Attribute namespace changed:* The top-level attribute key was changed from `newrelic-infra` to `newrelic_infra` in order to be used as both strings and symbols.
* Only `chef-client` versions `>= 12.14` are supported.
* Lots of attribute changes to help simplify configuration generation. See the [README][2] for more details.

FEATURES:

* *Testing added:* Unit and integration tests added. See the [CONTRIBUTING][3] guide for more details.
* *newrelic\_infra\_integration LWRP added:* An LWRP for installing and configuring custom New Relic Infrastructure on-host integrations. Custom integrations can also be installed using by including the default recipe and the appropriate attributes.
* *New Relic On-Host integrations:* Added the capability to install and configure the New Relic provided on-host integrations. See the [README][3] for more details on what attributes to set.

IMPROVEMENTS:

* Updated the apt and YUM repository resources to use metaprogramming. This allows all properties available for each of the respective resources to be available as attributes.
* Resolved all Rubocop and Foodcritic violations.

BUG FIXES:

[1]:  https://supermarket.chef.io/
[2]:  README.md
[3]:  CONTRIBUTING.md
