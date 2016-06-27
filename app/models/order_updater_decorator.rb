Spree::OrderUpdater.class_eval do
  def update_adjustment_total
    recalculate_adjustments
    order.adjustment_total = line_items.sum(:adjustment_total) +
                             shipments.sum(:adjustment_total)  +
                             adjustments.eligible.sum(:amount)

    order.included_tax_total = line_items.sum(:included_tax_total) +
                               shipments.sum(:included_tax_total)

    order.additional_tax_total = line_items.sum(:additional_tax_total) +
                                 shipments.sum(:additional_tax_total)

    order.promo_total = line_items.sum(:promo_total) +
                        shipments.sum(:promo_total) +
                        adjustments.promotion.eligible.sum(:amount)


    update_order_total
    if order.tax_zone == Spree::Zone.default_tax and order.adjustments.eligible.any?
      order_total_incl_tax = order.total

      order_total_excl_tax = 100*(order_total_incl_tax/121)
      order_tax = order_total_incl_tax - order_total_excl_tax
      order.update(included_tax_total: order_tax)
    end
  end

end
