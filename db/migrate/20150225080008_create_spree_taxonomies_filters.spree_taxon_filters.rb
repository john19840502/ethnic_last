# This migration comes from spree_taxon_filters (originally 20130429144351)
class CreateSpreeTaxonomiesFilters < ActiveRecord::Migration

  def change
    create_table :spree_taxonomies_filters, :id => false do |t|
      t.integer :taxonomy_id
      t.integer :filter_id
    end
  end

end