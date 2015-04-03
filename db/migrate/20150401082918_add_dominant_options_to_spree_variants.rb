class AddDominantOptionsToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :dominant_image_file_name, :string
    add_column :spree_variants, :dominant_image_file_size, :string
    add_column :spree_variants, :dominant_image_content_type, :string
    add_column :spree_variants, :dominant_color, :string
  end
end
