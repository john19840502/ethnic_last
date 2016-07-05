class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :spree_impression_brands, :brand_id
    add_index :spree_impression_brands, :impression_id
    add_index :spree_promotion_rules, [:id, :type]
    add_index :spree_properties_prototypes, [:property_id, :prototype_id], :name => "idx_props_proto_on_prop_id_and_proto_id"
    add_index :spree_properties_prototypes, [:prototype_id, :property_id], :name => "idx_props_proto_on_proto_id_and_prop_id"
    add_index :spree_option_types_prototypes, [:option_type_id, :prototype_id], :name => "idx_opt_proto_on_opt_id_and_proto_id"
    add_index :spree_option_types_prototypes, [:prototype_id, :option_type_id], :name => "idx_opt_proto_on_proto_id_and_opt_id"
    add_index :spree_option_values_variants, [:option_value_id, :variant_id], :name => "idx_optval_on_optval_id_and_var_id"
    add_index :spree_users, :ship_address_id
    add_index :spree_users, :bill_address_id
    add_index :spree_products_taxons, [:taxon_id, :product_id]
    add_index :spree_products_taxons, [:product_id, :taxon_id]
    add_index :spree_products_promotion_rules, [:promotion_rule_id, :product_id], :name => "idx_prod_promo_on_promo_rule_id_and_prod_id"
    add_index :spree_return_authorizations, :order_id

    add_index :spree_users, [:persistence_token], name: "idx_spree_users_index_users_on_persistence_token", using: :btree
    add_index :spree_backgrounds, [:taxon_id], name: "index_spree_backgrounds_on_taxon_id", using: :btree
  end
end
