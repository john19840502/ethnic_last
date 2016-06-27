class AddAsColorFilterToSpreeOptionTypes < ActiveRecord::Migration
  def change
    add_column :spree_option_types, :as_color_filter, :boolean, default: false
  end
end
