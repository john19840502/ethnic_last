class AddOptionValueImageUrlToProductVariantColors < ActiveRecord::Migration
  def change
    add_column :product_variant_colors, :option_value_image_url, :string
  end
end
