#
# Copyright (C) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

# Pulled from https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
def supported_platforms
  {
    redhat: %w(7.3 6.8),
    oracle: %w(7.2 6.8),
    centos: %w(7.4.1708 6.9),
    amazon: %w(2017.03 2013.09),
    debian: %w(9.1 8.9 7.11),
    ubuntu: %w(16.04 14.04),
  }
end

def unsupported_platforms
  {
    windows: %w(2012R2 2008R2),
  }
end
