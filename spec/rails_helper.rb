# spec/rails_helper.rb

# Load the Rails environment in test mode
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent running tests in production environment
abort("The Rails environment is running in production mode!") if Rails.env.production?

# Load RSpec and other testing dependencies
require 'rspec/rails'
require 'faker'
require 'factory_bot_rails'
require 'shoulda-matchers'
require 'devise'
# Configure RSpec
RSpec.configure do |config|
  # Include FactoryBot methods for easier factory creation
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Set the fixture path for tests
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Use transactional fixtures for test data cleanup
  config.use_transactional_fixtures = true

  # Infer the type of spec automatically from file location
  config.infer_spec_type_from_file_location!

  # Filter out Rails-specific backtrace lines from RSpec backtraces
  config.filter_rails_from_backtrace!

  # Configure Shoulda Matchers integration
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :active_record
      with.library :active_model
    end
  end
end
