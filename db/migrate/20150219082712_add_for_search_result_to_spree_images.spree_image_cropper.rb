# This migration comes from spree_image_cropper (originally 20130324132652)
class AddForSearchResultToSpreeImages < ActiveRecord::Migration
  def change
    add_column :spree_assets, :search_result_asset, :boolean, :default => false
  end
end
