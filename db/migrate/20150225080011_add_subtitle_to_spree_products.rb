class AddSubtitleToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :subtitle, :string
  end
end
