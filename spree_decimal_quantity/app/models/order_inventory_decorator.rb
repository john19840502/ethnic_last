Spree::OrderInventory.class_eval do
  def add_to_shipment(shipment, quantity)
    if variant.should_track_inventory?
      on_hand, back_order = shipment.stock_location.fill_status(variant, quantity)

      shipment.set_up_inventory('on_hand', variant, order, line_item, on_hand)
      shipment.set_up_inventory('backordered', variant, order, line_item, back_order)
    else
      shipment.set_up_inventory('on_hand', variant, order, line_item, quantity)
    end

    # adding to this shipment, and removing from stock_location
    if order.completed?
      shipment.stock_location.unstock(variant, quantity, shipment)
    end

    quantity
  end

  def verify(shipment = nil)
    if order.completed? || shipment.present?

      inventory_units_quantity = inventory_units.sum(:quantity)
      if inventory_units_quantity < line_item.quantity
        quantity = line_item.quantity - inventory_units_quantity

        shipment = determine_target_shipment unless shipment
        add_to_shipment(shipment, quantity)
      elsif inventory_units_quantity > line_item.quantity
        remove(inventory_units, shipment)
      end
    end
  end
end