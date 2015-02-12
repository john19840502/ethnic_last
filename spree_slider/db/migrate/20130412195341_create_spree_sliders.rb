class CreateSpreeSliders < ActiveRecord::Migration
  def change
    create_table :spree_sliders do |t|
      t.string :url
      t.string :group_key
      t.integer :position
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
  end
end
