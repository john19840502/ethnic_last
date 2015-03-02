Spree::Order.class_eval do

  def delivery_quote_needed?
    self.shipments.empty?
  end

  def confirmable?
    shipping_method.present?
  end

  checkout_flow do
    go_to_state :address
    go_to_state :delivery, :if => lambda { |order| (!order.delivery_quote_needed?) }
    go_to_state :delivery_quote, :if => lambda { |order| order.delivery_quote_needed? }
    # go_to_state :confirm, :if => lambda { |order|
    #   # Fix for #2191
    #   if order.shipping_method
    #     order.create_shipment!
    #     order.send(:update_totals)
    #   end
    #   order.confirmable?
    # }
    go_to_state :complete, :if => lambda { |order| (order.payment_required? && order.payments.exists?) || !order.payment_required? }
    #remove_transition :from => :delivery, :to => :confirm
    remove_transition :from => :delivery, :to => :payment
  end

end
