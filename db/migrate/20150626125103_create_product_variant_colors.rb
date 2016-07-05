class CreateProductVariantColors < ActiveRecord::Migration
  def change
    create_table :product_variant_colors, id: false do |t|
      t.integer :product_id
      t.integer :variant_id
      t.text    :colors, array:true, default: []
    end
  end
end
