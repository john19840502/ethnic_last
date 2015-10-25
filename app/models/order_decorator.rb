Spree::Order.class_eval do

  insert_checkout_step :before_address, before: :address

  def pre_tax_amount
    line_items.sum(:pre_tax_amount)
  end

  def delivery_quote_needed?
    Spree::ShippingMethod.available_on_frontend.empty?
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
  end

end
