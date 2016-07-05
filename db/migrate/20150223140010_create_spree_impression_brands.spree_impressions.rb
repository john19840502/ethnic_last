# This migration comes from spree_impressions (originally 20130413202804)
class CreateSpreeImpressionBrands < ActiveRecord::Migration
  def change
    create_table :spree_impression_brands do |t|
      t.integer :impression_id
      t.integer :brand_id
      t.integer :position

      t.timestamps
    end
  end
end
