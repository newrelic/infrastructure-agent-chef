#
# Copyright:: (C) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

# Pulled from https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
def supported_platforms
  {
    redhat: %w(8 7.7 7.6 6.10),
    oracle: %w(7.6 7.5 6.10 6.9),
    centos: %w(8 7.7.1908 7.6.1810 6.10 6.9),
    amazon: %w(2 2018.03 2017.09 2017.03 2016.09 2016.03),
    debian: %w(10 9.11 9.9 9.8 8.11 8.10 8.9),
    ubuntu: %w(20.04 18.04 16.04),
    suse: %w(15 12.5 12.4),
  }
end

def unsupported_platforms
  {
    windows: %w(2012R2 2008R2),
  }
end
