# This migration comes from spree (originally 20141012083513)
class CreateSpreeTaxonsPrototypes < ActiveRecord::Migration
  def change
    create_table :spree_taxons_prototypes do |t|
      t.belongs_to :taxon, show: true
      t.belongs_to :prototype, show: true
    end
  end
end
