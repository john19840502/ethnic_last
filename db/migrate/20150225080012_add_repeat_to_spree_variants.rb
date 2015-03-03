class AddRepeatToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :repeat, :integer
  end
end
