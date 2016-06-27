class AddHoveOverToCollectionImages < ActiveRecord::Migration
  def change
    add_column :collection_images, :hove_over, :boolean, default: false
  end
end
