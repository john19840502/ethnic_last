class MigrateOldDbToEthnicchick2 < ActiveRecord::Migration
  def change
    rename_table :spree_activators, :spree_promotions

    create_table "friendly_id_slugs", force: :cascade do |t|
      t.string   "slug",                      null: false
      t.integer  "sluggable_id",              null: false
      t.string   "sluggable_type", limit: 50
      t.string   "scope"
      t.datetime "created_at"
    end

    add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree


    # Adjustments

    # remove_index "spree_adjustments", ["originator_id", "originator_type"]
    remove_column :spree_adjustments, :locked
    remove_column :spree_adjustments, :originator_id
    remove_column :spree_adjustments, :originator_type
    add_column :spree_adjustments, :state, :string
    add_column :spree_adjustments, :order_id, :integer
    add_column :spree_adjustments, :included, :boolean, default: false
    add_index "spree_adjustments", ["eligible"], name: "index_spree_adjustments_on_eligible", using: :btree
    add_index "spree_adjustments", ["order_id"], name: "index_spree_adjustments_on_order_id", using: :btree

    # Assets

    add_column :spree_assets, :created_at, :datetime
    add_column :spree_assets, :updated_at, :datetime

    # Backgrounds

    # remove_index "spree_backgrounds", ["brand_id"]
    remove_column :spree_backgrounds, :brand_id
    add_column :spree_backgrounds, :taxon_id, :integer
    add_index "spree_backgrounds", ["taxon_id"]

    # Blog entries

    drop_table :spree_blog_entries

    # Calculators

    add_column :spree_calculators, :preferences, :text

    # Configurations

    drop_table :spree_configurations

    # Countries

    add_column :spree_countries, :states_required, :boolean, default: false
    add_column :spree_countries, :updated_at, :datetime


    # Credit Cards

    change_table(:spree_credit_cards) do |t|
      t.remove :first_name
      t.remove :last_name
      t.remove :start_month
      t.remove :start_year
      t.remove :issue_number

      t.string   "name"
      t.integer  "user_id"
      t.integer  "payment_method_id"
      t.boolean  "default",                     default: false, null: false
    end

    add_index "spree_credit_cards", ["address_id"], name: "index_spree_credit_cards_on_address_id", using: :btree
    add_index "spree_credit_cards", ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id", using: :btree
    add_index "spree_credit_cards", ["user_id"], name: "index_spree_credit_cards_on_user_id", using: :btree


    # Customer returns

    create_table "spree_customer_returns", force: :cascade do |t|
      t.string   "number"
      t.integer  "stock_location_id"
      t.datetime "created_at",        null: false
      t.datetime "updated_at",        null: false
    end

    # Gateways

    add_column :spree_gateways, :preferences, :text
    add_index "spree_gateways", ["active"], name: "index_spree_gateways_on_active", using: :btree
    add_index "spree_gateways", ["test_mode"], name: "index_spree_gateways_on_test_mode", using: :btree

    # Inventory Units

    change_table :spree_inventory_units do |t|
      #t.remove_index["return_authorization_id"]
      t.remove :lock_version
      t.remove :return_authorization_id
      t.boolean  "pending",      default: true
      t.integer  "line_item_id"
    end

    add_index "spree_inventory_units", ["line_item_id"], name: "index_spree_inventory_units_on_line_item_id", using: :btree

    # Line Items

    change_table :spree_line_items do |t|
      t.string   "currency"
      t.decimal  "cost_price",           precision: 10, scale: 2
      t.integer  "tax_category_id"
      t.decimal  "adjustment_total",     precision: 10, scale: 2, default: 0.0
      t.decimal  "additional_tax_total", precision: 10, scale: 2, default: 0.0
      t.decimal  "promo_total",          precision: 10, scale: 2, default: 0.0
      t.decimal  "included_tax_total",   precision: 10, scale: 2, default: 0.0, null: false
      t.decimal  "pre_tax_amount",       precision: 8,  scale: 2, default: 0.0
    end

    add_index "spree_line_items", ["tax_category_id"], name: "index_spree_line_items_on_tax_category_id", using: :btree

    # Mail methods

    drop_table :spree_mail_methods

    # Option types

    add_index "spree_option_types", ["position"], name: "index_spree_option_types_on_position", using: :btree

    # Option values

    add_index "spree_option_values", ["position"], name: "index_spree_option_values_on_position", using: :btree

    # Orders

    change_table :spree_orders do |t|
      t.remove :docdata_payment_cluster_key

      t.string   "currency"
      t.string   "last_ip_address"
      t.integer  "created_by_id"
      t.decimal  "shipment_total",                    precision: 10, scale: 2, default: 0.0,     null: false
      t.decimal  "additional_tax_total",              precision: 10, scale: 2, default: 0.0
      t.decimal  "promo_total",                       precision: 10, scale: 2, default: 0.0
      t.string   "channel",                                                    default: "spree"
      t.decimal  "included_tax_total",                precision: 10, scale: 2, default: 0.0,     null: false
      t.integer  "item_count",                                                 default: 0
      t.integer  "approver_id"
      t.datetime "approved_at"
      t.boolean  "confirmation_delivered",                                     default: false
      t.boolean  "considered_risky",                                           default: false
      t.string   "guest_token"
      t.datetime "canceled_at"
      t.integer  "canceler_id"
      t.integer  "store_id"
      t.integer  "state_lock_version",                                         default: 0,       null: false
    end

    add_index "spree_orders", ["approver_id"], name: "index_spree_orders_on_approver_id", using: :btree
    add_index "spree_orders", ["completed_at"], name: "index_spree_orders_on_completed_at", using: :btree
    add_index "spree_orders", ["confirmation_delivered"], name: "index_spree_orders_on_confirmation_delivered", using: :btree
    add_index "spree_orders", ["considered_risky"], name: "index_spree_orders_on_considered_risky", using: :btree
    add_index "spree_orders", ["created_by_id"], name: "index_spree_orders_on_created_by_id", using: :btree
    add_index "spree_orders", ["guest_token"], name: "index_spree_orders_on_guest_token", using: :btree
    add_index "spree_orders", ["user_id", "created_by_id"], name: "index_spree_orders_on_user_id_and_created_by_id", using: :btree


    # Orders Promotions

    create_table "spree_orders_promotions", id: false, force: :cascade do |t|
      t.integer "order_id"
      t.integer "promotion_id"
    end

    add_index "spree_orders_promotions", ["order_id", "promotion_id"], name: "index_spree_orders_promotions_on_order_id_and_promotion_id", using: :btree

    # Page Stores

    create_table "spree_pages_stores", id: false, force: :cascade do |t|
      t.integer  "store_id"
      t.integer  "page_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "spree_pages_stores", ["page_id"], name: "index_spree_pages_stores_on_page_id", using: :btree
    add_index "spree_pages_stores", ["store_id"], name: "index_spree_pages_stores_on_store_id", using: :btree

    # Page Stores

    create_table "spree_payment_capture_events", force: :cascade do |t|
      t.decimal  "amount",     precision: 10, scale: 2, default: 0.0
      t.integer  "payment_id"
      t.datetime "created_at",                                        null: false
      t.datetime "updated_at",                                        null: false
    end

    add_index "spree_payment_capture_events", ["payment_id"], name: "index_spree_payment_capture_events_on_payment_id", using: :btree

    # Payment Methods

    change_table :spree_payment_methods do |t|
      t.remove   "environment"

      t.boolean  "auto_capture"
      t.text     "preferences"
    end

    #Payments

    change_table :spree_payments do |t|
      t.remove "identifier"

      t.string   "number"
      t.string   "cvv_response_code"
      t.string   "cvv_response_message"
    end

    # Paypal accounts

    drop_table :spree_paypal_accounts

    # Pending Promotions

    drop_table :spree_pending_promotions

    # Preferences

    change_table "spree_preferences" do |t|
      t.remove   "name"
      t.remove  "owner_id"
      t.remove   "owner_type"
      t.remove   "value_type"
    end

    # Prices

    create_table "spree_prices", force: :cascade do |t|
      t.integer  "variant_id",                          null: false
      t.decimal  "amount",     precision: 10, scale: 2
      t.string   "currency"
      t.datetime "deleted_at"
    end

    add_index "spree_prices", ["deleted_at"], name: "index_spree_prices_on_deleted_at", using: :btree
    add_index "spree_prices", ["variant_id", "currency"], name: "index_spree_prices_on_variant_id_and_currency", using: :btree

    # Product option types

    add_index "spree_product_option_types", ["position"], name: "index_spree_product_option_types_on_position", using: :btree

    # Product Properties

    add_column :spree_product_properties, :position, :integer, default: 0
    add_index "spree_product_properties", ["position"], name: "index_spree_product_properties_on_position", using: :btree

    # Products

    # remove_index "spree_products", ["brand_id"]
    # remove_index "spree_products", ["permalink"]
    change_table :spree_products do |t|
      t.rename "permalink", "slug"

      t.remove "count_on_hand"
      t.remove "brand_id"
      # Added in 20150225080011_add_subtitle_to_spree_products.rb
      # t.remove "subtitle"

      t.boolean  "promotionable",         default: true
      t.string   "meta_title"
    end

    change_column :spree_products, :meta_description, :text
    add_index "spree_products", ["slug"], name: "index_spree_products_on_slug", unique: true, using: :btree

    # Products Taxons

    add_column :spree_products_taxons, :position, :integer
    add_index "spree_products_taxons", ["position"], name: "index_spree_products_taxons_on_position", using: :btree

    # Promotion actions

    # remove_index "spree_promotion_actions", ["activator_id"]

    change_table "spree_promotion_actions" do |t|
      t.remove "activator_id"

      t.integer  "promotion_id"
      t.datetime "deleted_at"
    end

    add_index "spree_promotion_actions", ["deleted_at"], name: "index_spree_promotion_actions_on_deleted_at", using: :btree
    add_index "spree_promotion_actions", ["promotion_id"], name: "index_spree_promotion_actions_on_promotion_id", using: :btree

    # Promotion categories

    create_table "spree_promotion_categories", force: :cascade do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string   "code"
    end

    # Promotion Rules

    # remove_index "spree_promotion_rules", ["activator_id"]
    # remove_index "spree_promotion_rules", ["id", "type"]
    # remove_index "spree_promotion_rules", ["product_group_id"]

    change_table "spree_promotion_rules", force: :cascade do |t|
      t.remove "activator_id"

      t.integer  "promotion_id"
      t.string   "code"
      t.text     "preferences"
    end

    add_index "spree_promotion_rules", ["product_group_id"], name: "index_promotion_rules_on_product_group_id", using: :btree
    add_index "spree_promotion_rules", ["promotion_id"], name: "index_spree_promotion_rules_on_promotion_id", using: :btree

    # Promotions

    create_table "spree_promotions", force: :cascade do |t|
      t.string   "description"
      t.datetime "expires_at"
      t.datetime "starts_at"
      t.string   "name"
      t.string   "type"
      t.integer  "usage_limit"
      t.string   "match_policy",          default: "all"
      t.string   "code"
      t.boolean  "advertise",             default: false
      t.string   "path"
      t.datetime "created_at",                            null: false
      t.datetime "updated_at",                            null: false
      t.integer  "promotion_category_id"
    end

    add_index "spree_promotions", ["advertise"], name: "index_spree_promotions_on_advertise", using: :btree
    add_index "spree_promotions", ["code"], name: "index_spree_promotions_on_code", using: :btree
    add_index "spree_promotions", ["expires_at"], name: "index_spree_promotions_on_expires_at", using: :btree
    add_index "spree_promotions", ["id", "type"], name: "index_spree_promotions_on_id_and_type", using: :btree
    add_index "spree_promotions", ["promotion_category_id"], name: "index_spree_promotions_on_promotion_category_id", using: :btree
    add_index "spree_promotions", ["starts_at"], name: "index_spree_promotions_on_starts_at", using: :btree


    # Refunds, Reimbursments

    create_table "spree_refund_reasons", force: :cascade do |t|
      t.string   "name"
      t.boolean  "active",     default: true
      t.boolean  "mutable",    default: true
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
    end

    create_table "spree_refunds", force: :cascade do |t|
      t.integer  "payment_id"
      t.decimal  "amount",           precision: 10, scale: 2, default: 0.0, null: false
      t.string   "transaction_id"
      t.datetime "created_at",                                              null: false
      t.datetime "updated_at",                                              null: false
      t.integer  "refund_reason_id"
      t.integer  "reimbursement_id"
    end

    add_index "spree_refunds", ["refund_reason_id"], name: "index_refunds_on_refund_reason_id", using: :btree

    create_table "spree_reimbursement_credits", force: :cascade do |t|
      t.decimal "amount",           precision: 10, scale: 2, default: 0.0, null: false
      t.integer "reimbursement_id"
      t.integer "creditable_id"
      t.string  "creditable_type"
    end

    create_table "spree_reimbursement_types", force: :cascade do |t|
      t.string   "name"
      t.boolean  "active",     default: true
      t.boolean  "mutable",    default: true
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
      t.string   "type"
    end

    add_index "spree_reimbursement_types", ["type"], name: "index_spree_reimbursement_types_on_type", using: :btree

    create_table "spree_reimbursements", force: :cascade do |t|
      t.string   "number"
      t.string   "reimbursement_status"
      t.integer  "customer_return_id"
      t.integer  "order_id"
      t.decimal  "total",                precision: 10, scale: 2
      t.datetime "created_at",                                    null: false
      t.datetime "updated_at",                                    null: false
    end

    add_index "spree_reimbursements", ["customer_return_id"], name: "index_spree_reimbursements_on_customer_return_id", using: :btree
    add_index "spree_reimbursements", ["order_id"], name: "index_spree_reimbursements_on_order_id", using: :btree

    create_table "spree_return_authorization_reasons", force: :cascade do |t|
      t.string   "name"
      t.boolean  "active",     default: true
      t.boolean  "mutable",    default: true
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
    end

    # Return authorizations

    # remove_index "spree_return_authorizations", ["order_id"]

    change_table "spree_return_authorizations" do |t|
      t.remove "amount"
      t.remove "reason"

      t.text     "memo"
      t.integer  "stock_location_id"
      t.integer  "return_authorization_reason_id"
    end

    add_index "spree_return_authorizations", ["return_authorization_reason_id"], name: "index_return_authorizations_on_return_authorization_reason_id", using: :btree

    # Return items

    create_table "spree_return_items", force: :cascade do |t|
      t.integer  "return_authorization_id"
      t.integer  "inventory_unit_id"
      t.integer  "exchange_variant_id"
      t.datetime "created_at",                                                              null: false
      t.datetime "updated_at",                                                              null: false
      t.decimal  "pre_tax_amount",                  precision: 12, scale: 4, default: 0.0,  null: false
      t.decimal  "included_tax_total",              precision: 12, scale: 4, default: 0.0,  null: false
      t.decimal  "additional_tax_total",            precision: 12, scale: 4, default: 0.0,  null: false
      t.string   "reception_status"
      t.string   "acceptance_status"
      t.integer  "customer_return_id"
      t.integer  "reimbursement_id"
      t.integer  "exchange_inventory_unit_id"
      t.text     "acceptance_status_errors"
      t.integer  "preferred_reimbursement_type_id"
      t.integer  "override_reimbursement_type_id"
      t.boolean  "resellable",                                               default: true, null: false
    end

    add_index "spree_return_items", ["customer_return_id"], name: "index_return_items_on_customer_return_id", using: :btree
    add_index "spree_return_items", ["exchange_inventory_unit_id"], name: "index_spree_return_items_on_exchange_inventory_unit_id", using: :btree

    # Shipments

    # remove_index "spree_shipments", ["shipping_method_id"]

    change_table "spree_shipments", force: :cascade do |t|
      t.remove "shipping_method_id"

      t.integer  "stock_location_id"
      t.decimal  "adjustment_total",     precision: 10, scale: 2, default: 0.0
      t.decimal  "additional_tax_total", precision: 10, scale: 2, default: 0.0
      t.decimal  "promo_total",          precision: 10, scale: 2, default: 0.0
      t.decimal  "included_tax_total",   precision: 10, scale: 2, default: 0.0, null: false
      t.decimal  "pre_tax_amount",       precision: 8,  scale: 2, default: 0.0
    end

    add_index "spree_shipments", ["stock_location_id"], name: "index_spree_shipments_on_stock_location_id", using: :btree

    # Shipping method Categories

    create_table "spree_shipping_method_categories", force: :cascade do |t|
      t.integer  "shipping_method_id",   null: false
      t.integer  "shipping_category_id", null: false
      t.datetime "created_at",           null: false
      t.datetime "updated_at",           null: false
    end

    add_index "spree_shipping_method_categories", ["shipping_category_id", "shipping_method_id"], name: "unique_spree_shipping_method_categories", unique: true, using: :btree
    add_index "spree_shipping_method_categories", ["shipping_method_id"], name: "index_spree_shipping_method_categories_on_shipping_method_id", using: :btree

    # Shipping methods

    # remove_index "spree_shipping_methods", ["shipping_category_id"]
    # remove_index "spree_shipping_methods", ["zone_id"]

    change_table "spree_shipping_methods" do |t|
      t.remove  "zone_id"
      t.remove  "shipping_category_id"
      t.remove  "match_none"
      t.remove  "match_all"
      t.remove  "match_one"

      t.string   "tracking_url"
      t.string   "admin_name"
      t.integer  "tax_category_id"
      t.string   "code"
    end

    add_index "spree_shipping_methods", ["deleted_at"], name: "index_spree_shipping_methods_on_deleted_at", using: :btree
    add_index "spree_shipping_methods", ["tax_category_id"], name: "index_spree_shipping_methods_on_tax_category_id", using: :btree


    # Shipping method zones

    create_table "spree_shipping_methods_zones", id: false, force: :cascade do |t|
      t.integer "shipping_method_id"
      t.integer "zone_id"
    end

    # Shipping method rates

    create_table "spree_shipping_rates", force: :cascade do |t|
      t.integer  "shipment_id"
      t.integer  "shipping_method_id"
      t.boolean  "selected",                                   default: false
      t.decimal  "cost",               precision: 8, scale: 2, default: 0.0
      t.datetime "created_at",                                                 null: false
      t.datetime "updated_at",                                                 null: false
      t.integer  "tax_rate_id"
    end

    add_index "spree_shipping_rates", ["selected"], name: "index_spree_shipping_rates_on_selected", using: :btree
    add_index "spree_shipping_rates", ["shipment_id", "shipping_method_id"], name: "spree_shipping_rates_join_index", unique: true, using: :btree
    add_index "spree_shipping_rates", ["tax_rate_id"], name: "index_spree_shipping_rates_on_tax_rate_id", using: :btree

    # States

    add_column :spree_states, "updated_at", :datetime

    # Stock items

    create_table "spree_stock_items", force: :cascade do |t|
      t.integer  "stock_location_id"
      t.integer  "variant_id"
      t.integer  "count_on_hand",     default: 0,     null: false
      t.datetime "created_at",                        null: false
      t.datetime "updated_at",                        null: false
      t.boolean  "backorderable",     default: false
      t.datetime "deleted_at"
    end

    add_index "spree_stock_items", ["backorderable"], name: "index_spree_stock_items_on_backorderable", using: :btree
    add_index "spree_stock_items", ["deleted_at"], name: "index_spree_stock_items_on_deleted_at", using: :btree
    add_index "spree_stock_items", ["stock_location_id", "variant_id"], name: "stock_item_by_loc_and_var_id", using: :btree
    add_index "spree_stock_items", ["stock_location_id"], name: "index_spree_stock_items_on_stock_location_id", using: :btree
    add_index "spree_stock_items", ["variant_id"], name: "index_spree_stock_items_on_variant_id", using: :btree


    # Stock locations

    create_table "spree_stock_locations", force: :cascade do |t|
      t.string   "name"
      t.datetime "created_at",                             null: false
      t.datetime "updated_at",                             null: false
      t.boolean  "default",                default: false, null: false
      t.string   "address1"
      t.string   "address2"
      t.string   "city"
      t.integer  "state_id"
      t.string   "state_name"
      t.integer  "country_id"
      t.string   "zipcode"
      t.string   "phone"
      t.boolean  "active",                 default: true
      t.boolean  "backorderable_default",  default: false
      t.boolean  "propagate_all_variants", default: true
      t.string   "admin_name"
    end

    add_index "spree_stock_locations", ["active"], name: "index_spree_stock_locations_on_active", using: :btree
    add_index "spree_stock_locations", ["backorderable_default"], name: "index_spree_stock_locations_on_backorderable_default", using: :btree
    add_index "spree_stock_locations", ["country_id"], name: "index_spree_stock_locations_on_country_id", using: :btree
    add_index "spree_stock_locations", ["propagate_all_variants"], name: "index_spree_stock_locations_on_propagate_all_variants", using: :btree
    add_index "spree_stock_locations", ["state_id"], name: "index_spree_stock_locations_on_state_id", using: :btree

    create_table "spree_stock_movements", force: :cascade do |t|
      t.integer  "stock_item_id"
      t.integer  "quantity",        default: 0
      t.string   "action"
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.integer  "originator_id"
      t.string   "originator_type"
    end

    add_index "spree_stock_movements", ["stock_item_id"], name: "index_spree_stock_movements_on_stock_item_id", using: :btree

    create_table "spree_stock_transfers", force: :cascade do |t|
      t.string   "type"
      t.string   "reference"
      t.integer  "source_location_id"
      t.integer  "destination_location_id"
      t.datetime "created_at",              null: false
      t.datetime "updated_at",              null: false
      t.string   "number"
    end

    add_index "spree_stock_transfers", ["destination_location_id"], name: "index_spree_stock_transfers_on_destination_location_id", using: :btree
    add_index "spree_stock_transfers", ["number"], name: "index_spree_stock_transfers_on_number", using: :btree
    add_index "spree_stock_transfers", ["source_location_id"], name: "index_spree_stock_transfers_on_source_location_id", using: :btree

    create_table "spree_stores", force: :cascade do |t|
      t.string   "name"
      t.string   "url"
      t.text     "meta_description"
      t.text     "meta_keywords"
      t.string   "seo_title"
      t.string   "mail_from_address"
      t.string   "default_currency"
      t.string   "code"
      t.boolean  "default",           default: false, null: false
      t.datetime "created_at",                        null: false
      t.datetime "updated_at",                        null: false
    end

    add_index "spree_stores", ["code"], name: "index_spree_stores_on_code", using: :btree
    add_index "spree_stores", ["default"], name: "index_spree_stores_on_default", using: :btree
    add_index "spree_stores", ["url"], name: "index_spree_stores_on_url", using: :btree

    # Tax categories

    add_column :spree_tax_categories, :tax_code, :string

    add_index "spree_tax_categories", ["deleted_at"], name: "index_spree_tax_categories_on_deleted_at", using: :btree
    add_index "spree_tax_categories", ["is_default"], name: "index_spree_tax_categories_on_is_default", using: :btree

    # Tax rates

    add_column :spree_tax_rates, :deleted_at, :datetime

    add_index "spree_tax_rates", ["deleted_at"], name: "index_spree_tax_rates_on_deleted_at", using: :btree
    add_index "spree_tax_rates", ["included_in_price"], name: "index_spree_tax_rates_on_included_in_price", using: :btree
    add_index "spree_tax_rates", ["show_rate_in_label"], name: "index_spree_tax_rates_on_show_rate_in_label", using: :btree

    # Taxonomies

    add_index "spree_taxonomies", ["position"], name: "index_spree_taxonomies_on_position", using: :btree

    # Taxons

    change_table "spree_taxons" do |t|
      t.string   "meta_title"
      t.string   "meta_description"
      t.string   "meta_keywords"
      t.integer  "depth"
      t.integer  "visibility",        default: 1
      t.boolean  "enabled",           default: true
    end

    add_index "spree_taxons", ["position"], name: "index_spree_taxons_on_position", using: :btree

    # Taxons promotion rules, taxons properties

    create_table "spree_taxons_promotion_rules", force: :cascade do |t|
      t.integer "taxon_id"
      t.integer "promotion_rule_id"
    end

    add_index "spree_taxons_promotion_rules", ["promotion_rule_id"], name: "index_spree_taxons_promotion_rules_on_promotion_rule_id", using: :btree
    add_index "spree_taxons_promotion_rules", ["taxon_id"], name: "index_spree_taxons_promotion_rules_on_taxon_id", using: :btree

    create_table "spree_taxons_prototypes", force: :cascade do |t|
      t.integer "taxon_id"
      t.integer "prototype_id"
    end

    add_index "spree_taxons_prototypes", ["prototype_id"], name: "index_spree_taxons_prototypes_on_prototype_id", using: :btree
    add_index "spree_taxons_prototypes", ["taxon_id"], name: "index_spree_taxons_prototypes_on_taxon_id", using: :btree

    # Trackers

    remove_column :spree_trackers, :environment
    add_index "spree_trackers", ["active"], name: "index_spree_trackers_on_active", using: :btree

    # Users

    change_table "spree_users" do |t|
      t.datetime "deleted_at"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
    end
    add_index "spree_users", ["deleted_at"], name: "index_spree_users_on_deleted_at", using: :btree
    add_index "spree_users", ["spree_api_key"], name: "index_spree_users_on_spree_api_key", using: :btree

    # Variants

    change_table "spree_variants", force: :cascade do |t|
      t.remove "price"
      t.remove  "count_on_hand"
      t.remove  "lock_version"
      t.remove  "repeat"

      t.string   "cost_currency"
      t.boolean  "track_inventory",                            default: true
      t.integer  "tax_category_id"
      t.datetime "updated_at"
      t.integer  "stock_items_count",                          default: 0,     null: false
    end

    add_index "spree_variants", ["deleted_at"], name: "index_spree_variants_on_deleted_at", using: :btree
    add_index "spree_variants", ["is_master"], name: "index_spree_variants_on_is_master", using: :btree
    add_index "spree_variants", ["position"], name: "index_spree_variants_on_position", using: :btree
    add_index "spree_variants", ["sku"], name: "index_spree_variants_on_sku", using: :btree
    add_index "spree_variants", ["tax_category_id"], name: "index_spree_variants_on_tax_category_id", using: :btree
    add_index "spree_variants", ["track_inventory"], name: "index_spree_variants_on_track_inventory", using: :btree
    add_index "spree_variants", ["product_id"], name: "index_spree_variants_on_product_id", using: :btree

    # Zones

    change_table "spree_zones" do |t|
      t.remove "for_popup"

      t.string   "kind"
    end

    add_index "spree_zones", ["default_tax"], name: "index_spree_zones_on_default_tax", using: :btree
    add_index "spree_zones", ["kind"], name: "index_spree_zones_on_kind", using: :btree

    # Taggings, Tags

    drop_table :taggings
    drop_table :tags

    # Old tables

    drop_table :activators
    drop_table :addresses
    drop_table :adjustments
    drop_table :assets
    drop_table :calculators
    drop_table :configurations
    drop_table :countries
    drop_table :coupons
    drop_table :creditcards
    drop_table :docdata_web_direct_checkouts
    drop_table :gateways
    drop_table :inventory_units
    drop_table :line_items
    drop_table :log_entries
    drop_table :mail_methods
    drop_table :option_types
    drop_table :option_types_prototypes
    drop_table :option_values
    drop_table :option_values_variants
    drop_table :orders
    drop_table :payment_methods
    drop_table :payments
    drop_table :preferences
    drop_table :product_option_types
    drop_table :product_properties
    drop_table :products
    drop_table :products_taxons
    drop_table :properties
    drop_table :properties_prototypes
    drop_table :prototypes
    drop_table :return_authorizations
    drop_table :roles
    drop_table :roles_users
    drop_table :shipments
    drop_table :spree_skrill_transactions
    drop_table :spree_tokenized_permissions
    drop_table :state_events
    drop_table :states
    drop_table :tax_categories
    drop_table :tax_rates
    drop_table :taxonomies
    drop_table :taxons
    drop_table :trackers
    drop_table :users
    drop_table :variants
    drop_table :zone_members
    drop_table :zones
    drop_table :shipping_categories
    drop_table :shipping_methods
    drop_table :spree_brands

    remove_index "spree_promotion_rules", name: "idx_spree_promotion_rules_index_promotion_rules_on_product__37"
    remove_index "spree_variants", name: "idx_spree_variants_index_spree_variants_on_product_id"
    remove_index "spree_products", name: "idx_spree_products_index_spree_products_on_permalink"

  end
end
