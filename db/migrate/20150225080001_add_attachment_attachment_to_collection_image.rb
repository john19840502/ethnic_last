class AddAttachmentAttachmentToCollectionImage < ActiveRecord::Migration
  def self.up
    add_column :collection_images, :attachment_file_name, :string
    add_column :collection_images, :attachment_content_type, :string
    add_column :collection_images, :attachment_file_size, :integer
    add_column :collection_images, :attachment_updated_at, :datetime
  end

  def self.down
    remove_column :collection_images, :attachment_file_name
    remove_column :collection_images, :attachment_content_type
    remove_column :collection_images, :attachment_file_size
    remove_column :collection_images, :attachment_updated_at
  end
end
