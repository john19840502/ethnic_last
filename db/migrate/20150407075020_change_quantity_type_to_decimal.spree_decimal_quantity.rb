# This migration comes from spree_decimal_quantity (originally 20150401093219)
class ChangeQuantityTypeToDecimal < ActiveRecord::Migration
  def change
    change_column :spree_line_items, :quantity, :decimal, precision: 10, scale: 2, default: 0.0
    change_column :spree_promotion_action_line_items, :quantity, :decimal, precision: 10, scale: 2, default: 0.0
    change_column :spree_stock_movements, :quantity, :decimal, precision: 10, scale: 2, default: 0.0
    change_column :spree_orders, :item_count, :decimal, precision: 10, scale: 2, default: 0.0
    change_column :spree_stock_items, :count_on_hand, :decimal, precision: 10, scale: 2, defaul: 0.0, null: false

    add_column :spree_inventory_units, :quantity, :decimal, precision: 10, scale: 2, default: 1.0
  end
end
