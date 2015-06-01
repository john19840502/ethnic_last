# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_decimal_quantity'
  s.version     = '3.0.0'
  s.summary     = 'Be able to use decimal line item quantities'
  s.description = s.summary
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'PeRo ICT Solutions'
  # s.email     = 'you@example.com'
  # s.homepage  = 'http://www.spreecommerce.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.0.0'

  # s.add_development_dependency 'capybara', '~> 2.4'
  # s.add_development_dependency 'coffee-rails'
  # s.add_development_dependency 'database_cleaner'
  # s.add_development_dependency 'factory_girl', '~> 4.5'
  # s.add_development_dependency 'ffaker'
  # s.add_development_dependency 'rspec-rails',  '~> 3.1'
  # s.add_development_dependency 'sass-rails', '~> 5.0.0.beta1'
  # s.add_development_dependency 'selenium-webdriver'
  # s.add_development_dependency 'simplecov'
  # s.add_development_dependency 'sqlite3'
  # s.add_development_dependency 'webmock'
  # s.add_dependency(%q<email_spec>, ["~> 1.6"])

  s.add_dependency 'activemerchant', '~> 1.47.0'
  s.add_dependency 'acts_as_list', '~> 0.6'
  s.add_dependency 'awesome_nested_set', '~> 3.0.1'
  s.add_dependency 'carmen', '~> 1.0.0'
  s.add_dependency 'cancancan', '~> 1.10.1'
  s.add_dependency 'deface', '~> 1.0.0'
  s.add_dependency 'ffaker', '~> 1.16'
  s.add_dependency 'font-awesome-rails', '~> 4.0'
  s.add_dependency 'friendly_id', '~> 5.1.0'
  s.add_dependency 'highline', '~> 1.6.18' # Necessary for the install generator
  s.add_dependency 'httparty', '~> 0.11' # For checking alerts.
  s.add_dependency 'json', '~> 1.7'
  s.add_dependency 'kaminari', '~> 0.15', '>= 0.15.1'
  s.add_dependency 'monetize', '~> 1.1'
  s.add_dependency 'paperclip', '~> 4.2.0'
  s.add_dependency 'paranoia', '~> 2.1.0'
  s.add_dependency 'premailer-rails'
  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'ransack', '~> 1.4.1'
  s.add_dependency 'responders'
  s.add_dependency 'state_machines-activerecord', '~> 0.2'
  s.add_dependency 'stringex'
  s.add_dependency 'truncate_html', '0.9.2'
  s.add_dependency 'twitter_cldr', '~> 3.0'
  s.add_development_dependency 'email_spec', '~> 1.6'


end
