# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Requires factories and other useful helpers defined in spree_core.
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree_mollie/factories/payment_method_factory'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.include Spree::TestingSupport::UrlHelpers
  config.mock_with :rspec
  config.color = true
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
    Rails.cache.clear
  end

  # Before each spec check if it is a Javascript test and switch between using database transactions or not where necessary.
  config.before :each do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  # After each spec clean the database.
  config.after :each do
    DatabaseCleaner.clean
  end

  config.fail_fast = ENV['FAIL_FAST'] || false
  config.order = "random"
end


require 'capybara-webkit'
Capybara.javascript_driver = ENV['USE_SELENIUM_FOR_CAPYBARA'] ? :selenium : :webkit

# Add VCR support.
#   require 'vcr'
#   require 'webmock/rspec'
#   VCR.configure do |config|
#     config.cassette_library_dir = 'spec/vcr_cassettes'
#     config.hook_into :webmock
#     config.ignore_localhost = true
#   end

ENV['MOLLIE_TEST_API_KEY'] ||= 'test_pw5ZHNihuiFKefzBwZVwAdKXt5C4Xe'
