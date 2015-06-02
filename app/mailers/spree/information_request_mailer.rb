module Spree
  class InformationRequestMailer < BaseMailer
    add_template_helper(Spree::BaseHelper)
    include Spree::Core::Engine.routes.url_helpers

    default from: 'info@ethnicchic.com'

    def information_request_email(request)
      @information_req = request
      subject = "#{Spree::Store.current.name} : Information Request"
      mail(to: from_address, from: 'noreply@ethnicchic.com', subject: subject)
    end
  end
end
