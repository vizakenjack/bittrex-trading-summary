ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment",__FILE__)
require 'rspec/rails'
require 'database_cleaner'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
