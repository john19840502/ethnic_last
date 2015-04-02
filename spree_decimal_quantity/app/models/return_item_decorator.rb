Spree::ReturnItem.class_eval do
  private

  def process_inventory_unit!
    inventory_unit.return!

    Spree::StockMovement.create!(stock_item_id: stock_item.id, quantity: inventory_unit.quantity) if should_restock?
  end
end
