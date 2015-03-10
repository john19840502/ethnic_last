require "application_responder"

class ApplicationController < ActionController::Base
  helper 'spree/base'
  include Spree::Core::ControllerHelpers::Order
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
