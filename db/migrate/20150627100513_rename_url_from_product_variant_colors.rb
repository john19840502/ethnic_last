class RenameUrlFromProductVariantColors < ActiveRecord::Migration
  def change
    remove_column :product_variant_colors, :option_value_image_url
    add_column :product_variant_colors, :option_value_id, :integer
  end
end
