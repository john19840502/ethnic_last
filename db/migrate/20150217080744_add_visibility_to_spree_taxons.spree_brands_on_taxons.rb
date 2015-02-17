# This migration comes from spree_brands_on_taxons (originally 20150213062929)
class AddVisibilityToSpreeTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :visibility, :integer, default: 1
  end
end
