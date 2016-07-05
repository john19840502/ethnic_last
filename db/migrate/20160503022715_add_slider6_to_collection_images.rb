class AddSlider6ToCollectionImages < ActiveRecord::Migration
  def change
    add_column :collection_images, :slider6, :boolean, default: false
  end
end
