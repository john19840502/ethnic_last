Spree::ShippingMethod.class_eval do
  scope :available_on_frontend, -> { where("display_on is null or display_on != 'back_end'") }
end