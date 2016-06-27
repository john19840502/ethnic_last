class AddVisibilityToSpreeTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :visibility, :integer, default: 1
  end
end
