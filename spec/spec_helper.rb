# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.dirname(__FILE__) + "/rails_3_0_9_root/config/environment", __FILE__)
require 'factory_girl'
FactoryGirl.find_definitions
require 'rspec/rails'

Dir[File.expand_path(File.dirname(__FILE__) + "/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
end
