class AddEnabledColumnToTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :enabled, :boolean, :default => true
  end
end
