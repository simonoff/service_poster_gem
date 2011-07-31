ENV['BUNDLE_GEMFILE'] = File.dirname(__FILE__) + '/../rails_3_0_9_root/Gemfile'

require 'rake'
require 'rake/testtask'
require 'rspec'
require 'rspec/core/rake_task'
require 'fileutils'

desc "Run the test suite"
task :spec => ['spec:setup', 'spec:model', 'spec:routing', 'spec:controller',
               'spec:cleanup']

namespace :spec do
  desc "Setup the test environment"
  task :setup do
    rails_path = File.expand_path(File.dirname(__FILE__) + '/../rails_3_0_9_root')
    system "cd #{rails_path} && bundle install"
    system "cd #{rails_path} && RAILS_ENV=test bundle exec rake db:migrate"
  end

  desc "Cleanup the test environment"
  task :cleanup do
    rails_path = File.expand_path(File.dirname(__FILE__) + '/../rails_3_0_9_root')
    FileUtils.rm_rf("#{rails_path}/Gemfile.lock")
    FileUtils.rm_rf("#{rails_path}/db/*.sqlite3")
  end

  desc "Test the rules_engine models"
  RSpec::Core::RakeTask.new(:model) do |task|
    my_engine_root = File.expand_path(File.dirname(__FILE__) + '/../..')
    task.pattern = my_engine_root + '/spec/models/**/*_spec.rb'
  end

  desc "Test the rules_engine routing"
  RSpec::Core::RakeTask.new(:routing) do |task|
    my_engine_root = File.expand_path(File.dirname(__FILE__) + '/../..')
    task.pattern = my_engine_root + '/spec/routing/**/*_spec.rb'
  end

  desc "Test the rules_engine controller helpers"
  RSpec::Core::RakeTask.new(:controller) do |task|
    my_engine_root = File.expand_path(File.dirname(__FILE__) + '/../..')
    task.pattern = my_engine_root + '/spec/controllers/**/*_spec.rb'
  end

end
