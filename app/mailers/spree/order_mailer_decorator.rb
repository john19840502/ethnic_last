Spree::OrderMailer.class_eval do
  def send_invoice(order, resend = false, invoice_pdf)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
    subject += "#{Spree::Store.current.name} #{Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
    attachments['invoice.pdf'] = invoice_pdf
    debugger
    mail(to: @order.email, from: from_address, subject: subject)
  end
end