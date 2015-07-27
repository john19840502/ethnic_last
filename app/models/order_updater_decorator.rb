Spree::OrderUpdater.class_eval do
  def update_adjustment_total
    recalculate_adjustments
    order.adjustment_total = line_items.sum(:adjustment_total) +
                             shipments.sum(:adjustment_total)  +
                             adjustments.eligible.sum(:amount)
    order.included_tax_total = line_items.sum(:included_tax_total) + shipments.sum(:included_tax_total)
    order.additional_tax_total = line_items.sum(:additional_tax_total) + shipments.sum(:additional_tax_total)

    order.promo_total = line_items.sum(:promo_total) +
                        shipments.sum(:promo_total) +
                        adjustments.promotion.eligible.sum(:amount)

    promo_incl_tax = order.promo_total
    # fix tax on promo_total
    if promo_incl_tax > 0
      pre_tax_on_promo_amount = promo_incl_tax / (1.21)
      tax_promo_amount = promo_incl_tax - pre_tax_on_promo_amount
      # since the tax_promo_amount is a negative number we need to add it.
      order.included_tax_total = order.included_tax_total + tax_promo_amount
    end

    update_order_total
  end
end
