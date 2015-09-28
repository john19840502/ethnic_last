require 'spree/country_helpers'
Spree::BaseController.send :include, Spree::CountryHelpers
