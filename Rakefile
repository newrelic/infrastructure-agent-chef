# Style tests. cookstyle (rubocop) and Foodcritic
namespace :style do
  begin
    require 'rubocop/rake_task'

    desc 'Run Ruby style checks'
    RuboCop::RakeTask.new(:ruby) do |task|
      task.options << '--display-cop-names'
    end
  rescue LoadError => e
    puts ">>> Gem load error: #{e}, omitting style:ruby" unless ENV['CI']
  end

  begin
    require 'foodcritic'

    desc 'Run Chef style checks'
    FoodCritic::Rake::LintTask.new(:chef) do |t|
      t.options = {
        fail_tags: ['any'],
        progress: true
      }
    end
  rescue LoadError => e
    puts ">>> Gem load error: #{e}, omitting style:chef" unless ENV['CI']
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# ChefSpec
begin
  require 'rspec/core/rake_task'

  desc 'Run ChefSpec examples'
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = ['--color', '--format', 'progress']
  end
rescue LoadError => e
  puts ">>> Gem load error: #{e}, omitting spec" unless ENV['CI']
end

# test-kitchen
begin
  require 'kitchen/cli'

  namespace :integration do
    task :set_vagrant, [:regex] do
      ENV['KITCHEN_LOCAL_YAML'] = './.kitchen.yml'
    end

    task :vagrant, [:regex] => :set_vagrant do |_, args|
      Kitchen::CLI.new([], destroy: 'always').test args[:regex]
    end

    desc 'Run Test Kitchen with Vagrant'
    namespace :vagrant do
      task :list, [:regex] => :set_vagrant do |_, args|
        Kitchen::CLI.new([]).list args[:regex]
      end

      task :login, [:regex] => :set_vagrant do |_, args|
        Kitchen::CLI.new([]).login args[:regex]
      end

      task :create, [:regex] => :set_vagrant do |_, args|
        Kitchen::CLI.new([]).create args[:regex]
      end

      task :converge, [:regex] => :set_vagrant do |_, args|
        Kitchen::CLI.new([]).converge args[:regex]
      end

      task :setup, [:regex] => :set_vagrant do |_, args|
        Kitchen::CLI.new([]).setup args[:regex]
      end

      task :verify, [:regex] => :set_vagrant do |_, args|
        Kitchen::CLI.new([]).verify args[:regex]
      end

      task :destroy, [:regex] => :set_vagrant do |_, args|
        Kitchen::CLI.new([]).destroy args[:regex]
      end

      task :test, [:regex] => :set_vagrant do |_, args|
        Kitchen::CLI.new([], destroy: 'always').test args[:regex]
      end
    end
  end
rescue LoadError => e
  puts ">>> Gem load error: #{e}, omitting spec" unless ENV['CI']
end

# Default
task default: %w[style spec integration:vagrant]
