# This migration comes from spree_taxon_backgrounds (originally 20150217084216)
class CreateSpreeBackgrounds < ActiveRecord::Migration
  def change
    create_table :spree_backgrounds do |t|
      t.integer :position
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :taxon_id
      t.timestamps
    end
  end
end
