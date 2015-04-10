Spree::Calculator::Shipping::FlexiRate.class_eval do
  def compute_from_quantity(quantity)
    sum = 0
    max = self.preferred_max_items.to_i
    quantity.to_i.times do |i|
      # check max value to avoid divide by 0 errors
      if (max == 0 && i == 0) || (max > 0) && (i % max == 0)
        sum += self.preferred_first_item.to_f
      else
        sum += self.preferred_additional_item.to_f
      end
    end

    sum += ( quantity - quantity.to_i ) * ( quantity < 1 ? self.preferred_first_item.to_f : self.preferred_additional_item.to_f )

    sum.to_f
  end
end