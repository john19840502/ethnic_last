# This migration comes from spree_taxon_filters (originally 20130429141137)
class AddDefaultToIsAFilterToSpreeTaxonomies < ActiveRecord::Migration
  def change
    change_column :spree_taxonomies, :is_a_filter, :boolean, :default => false
  end
end
