# This migration comes from spree_brands_on_taxons (originally 20150213084505)
class AddEnabledColumnToTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :enabled, :boolean, :default => true
  end
end
