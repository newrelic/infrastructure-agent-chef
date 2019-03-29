#
# Copyright (C) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

# Pulled from https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
def supported_platforms
  {
    redhat: %w(7.5 6.9),
    oracle: %w(7.4 6.9),
    centos: %w(7.4.1708 6.9),
    amazon: %w(2018.03 2015.09),
    debian: %w(9.4 8.10 7.11),
    ubuntu: %w(18.04 16.04 14.04),
    suse: %w(11.4 12.2),
  }
end

def unsupported_platforms
  {
    windows: %w(2012R2 2008R2),
  }
end
