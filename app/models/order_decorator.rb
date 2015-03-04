Spree::Order.class_eval do

  def delivery_quote_needed?
    Rails.logger.error 'delivery_quote_called'
    create_proposed_shipments if shipments.empty?
    shipments.empty? # || shipments.any? { |shipment| shipment.shipping_rates.blank? }
  end

  def mollie_payment_method
    available_payment_methods.select{ |pm| pm.instance_of?(Spree::PaymentMethod::Mollie) }.first
  end

  checkout_flow do
    go_to_state :address
    go_to_state :delivery, :if => lambda {|order| !order.delivery_quote_needed? }
    go_to_state :delivery_quote, :if => lambda { |order| order.delivery_quote_needed? }
    go_to_state :payment, if: lambda { |order| order.payment_required? }
    go_to_state :complete, :if => lambda { |order| (order.payment_required? && order.payments.exists?) || !order.payment_required? }
    #remove_transition :from => :delivery, :to => :confirm
    remove_transition :from => :delivery, :to => :payment
  end

end
