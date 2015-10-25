Spree::Calculator::FlatPercentItemTotal.class_eval do
  def compute(object)

    if object.tax_zone == Spree::Zone.default_tax
      computed_amount  = (object.amount * preferred_flat_percent / 100).round(2)
    else
      computed_amount  = (object.pre_tax_amount * preferred_flat_percent / 100).round(2)
    end
    
    # We don't want to cause the promotion adjustments to push the order into a negative total.
    if computed_amount > object.amount
      object.amount
    else
      computed_amount
    end
  end
end
