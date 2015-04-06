Spree::OrderInventory.class_eval do

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

  private

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

  def remove(item_units, shipment = nil)
    quantity = item_units.sum(:quantity) - line_item.quantity

    if shipment.present?
      remove_from_shipment(shipment, quantity)
    else
      order.shipments.each do |shipment|
        break if quantity == 0
        quantity -= remove_from_shipment(shipment, quantity)
      end
    end
  end

  def remove_from_shipment(shipment, quantity)
    return 0 if quantity == 0 || shipment.shipped?

    shipment_units = shipment.inventory_units_for_item(line_item, variant).reject do |variant_unit|
      variant_unit.state == 'shipped'
    end.sort_by(&:state)

    quantity_to_remove = quantity

    shipment_units.each do |inventory_unit|
      break if quantity_to_remove == 0

      if inventory_unit.quantity > quantity_to_remove
        inventory_unit.quantity -= quantity_to_remove
        inventory_unit.save!
        quantity_to_remove = 0
      else
        quantity_to_remove -= inventory_unit.quantity
        inventory_unit.destroy
      end
    end
    removed_quantity = quantity - quantity_to_remove

    shipment.destroy if shipment.inventory_units.count == 0

    # removing this from shipment, and adding to stock_location
    if order.completed?
      shipment.stock_location.restock variant, removed_quantity, shipment
    end

    removed_quantity
  end
end