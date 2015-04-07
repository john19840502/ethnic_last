Spree::LineItem.class_eval do

  def quantity_in_centimeters?
    variant.quantity_in_centimeters?
  end

  def step
    quantity_in_centimeters? ? 0.1 : 1
  end

end
