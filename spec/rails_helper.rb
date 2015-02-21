ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

require 'simplecov'
SimpleCov.start 'rails'

Dir["#{SPEC_ROOT}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.lint
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
