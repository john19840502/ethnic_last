class AddColumnToCollectionImages < ActiveRecord::Migration
  def change
    add_column :collection_images, :new_tab, :boolean
  end
end
