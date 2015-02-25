class CreateCollectionImages < ActiveRecord::Migration
  def change
    create_table :collection_images do |t|
      t.string :name
      t.integer :position
      t.string :url
      t.string :attachment
      t.boolean :slider1, :default => false
      t.boolean :slider2, :default => false
      t.boolean :medium, :default => false
      t.boolean :small, :default => false

      t.timestamps
    end
  end
end
