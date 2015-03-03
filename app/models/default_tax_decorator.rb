Spree::Calculator::DefaultTax.class_eval do

  def compute_order(order)
    matched_line_items = order.line_items.select do |line_item|
      line_item.product.tax_category == rate.tax_category
    end

    line_items_total = matched_line_items.sum(&:total)
    if rate.included_in_price
      round_to_two_places(line_items_total - ( line_items_total / (1 + rate.amount) ) )
    else
      round_to_two_places(line_items_total * rate.amount)
    end
  end
  
end