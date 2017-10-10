#
# Copyright (C) 2016-2017 New Relic, Inc.
#
# All rights reserved.
#

require 'chefspec'
require 'chefspec/berkshelf'

Dir[File.join(__dir__, 'support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.log_level = :error
  config.file_cache_path = '/var/chef/cache'

  # Disable STDOUT and STDERR
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do
    # Redirect stderr and stdout
    $stderr = File.new(File.join(File.dirname(__FILE__), 'stderr.txt'), 'w')
    $stdout = File.new(File.join(File.dirname(__FILE__), 'stdout.txt'), 'w')
  end
  # Re-enable STDOUT and STDERR
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end

at_exit { ChefSpec::Coverage.report! }
