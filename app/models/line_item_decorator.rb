Spree::LineItem.class_eval do

  validates :quantity, numericality: { greater_than_or_equal_to: 1.0 }

  def quantity_in_centimeters?
    variant.quantity_in_centimeters?
  end

  def step
    quantity_in_centimeters? ? 0.1 : 1
  end

end
