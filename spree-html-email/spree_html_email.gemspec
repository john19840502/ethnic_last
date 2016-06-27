# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_html_email'
  s.version     = '1.3.0'
  s.summary     = 'HTML email support for Spree'
  s.description = "Provides html email templates for all Spree's outgoing emails. Uses ERB."
  s.required_ruby_version = '>= 2.0.0'

  s.author            = 'Joshua Nussbaum'
  s.email             = 'joshnuss@gmail.com'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.0.0.rc2'
  s.add_dependency 'sass-rails'
  s.add_dependency 'coffee-rails'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl'
end

