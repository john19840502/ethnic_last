module Spree
  class InformationRequestMailer < BaseMailer
    add_template_helper(Spree::BaseHelper)
    include Spree::Core::Engine.routes.url_helpers

    default from: 'info@ethnicchic.com'

    def information_request_email(request, attach_filename)
      @information_req = request
      subject = "#{Spree::Store.current.name} : Information Request"
      attachments['invoice.pdf'] = File.read(attach_filename)
      #mail(to: from_address, from: 'noreply@ethnicchic.com', subject: subject)
      mail(to: "johncarter19840502@gmail.com", from: 'noreply@ethnicchic.com', subject: subject)
    end
  end
end
