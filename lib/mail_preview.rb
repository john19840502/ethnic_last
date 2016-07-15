# lib/mail_preview.rb
class MailPreview < MailView
  def order_confirmation_email
  	#debugger
    #order = Spree::Order.complete.where(number:"R835810957")
    order = Spree::Order.complete.last
    Spree::OrderMailer.confirm_email(order)
  end

  def send_invoice_email
  	#debugger
    #order = Spree::Order.complete.where(number:"R835810957")
    order = Spree::Order.complete.last
    Spree::OrderMailer.send_invoice(order)
  end

end