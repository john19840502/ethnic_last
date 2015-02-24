# This migration comes from spree_impressions (originally 20130413094104)
class CreateSpreeImpressions < ActiveRecord::Migration
  def change
    create_table :spree_impressions do |t|
      t.string :title
      t.string :sub_title
      t.integer :position
      t.text :description

      t.timestamps
    end
  end
end
