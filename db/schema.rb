# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160504075728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "uuid-ossp"
  enable_extension "plpgsql"

  create_table "collection_images", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.integer  "position"
    t.string   "url",                     limit: 255
    t.string   "attachment",              limit: 255
    t.boolean  "slider1",                             default: false
    t.boolean  "slider2",                             default: false
    t.boolean  "medium",                              default: false
    t.boolean  "small",                               default: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.boolean  "new_tab"
    t.boolean  "slider6",                             default: false
    t.boolean  "hove_over",                           default: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "friendly_id_slugs", ["deleted_at"], name: "index_friendly_id_slugs_on_deleted_at", using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "information_requests", force: :cascade do |t|
    t.string   "email",       limit: 255
    t.string   "name",        limit: 255
    t.string   "company",     limit: 255
    t.text     "address"
    t.text     "question"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "product_url", limit: 255
  end

  create_table "product_variant_colors", id: false, force: :cascade do |t|
    t.integer "product_id"
    t.integer "variant_id"
    t.text    "colors",          default: [], array: true
    t.integer "option_value_id"
  end

  create_table "spree_addresses", force: :cascade do |t|
    t.string   "firstname",         limit: 255
    t.string   "lastname",          limit: 255
    t.string   "address1",          limit: 255
    t.string   "address2",          limit: 255
    t.string   "city",              limit: 255
    t.string   "zipcode",           limit: 255
    t.string   "phone",             limit: 255
    t.string   "state_name",        limit: 255
    t.string   "alternative_phone", limit: 255
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "company",           limit: 255
  end

  add_index "spree_addresses", ["country_id"], name: "idx_spree_addresses_index_spree_addresses_on_country_id", using: :btree
  add_index "spree_addresses", ["firstname"], name: "idx_spree_addresses_index_addresses_on_firstname", using: :btree
  add_index "spree_addresses", ["lastname"], name: "idx_spree_addresses_index_addresses_on_lastname", using: :btree
  add_index "spree_addresses", ["state_id"], name: "idx_spree_addresses_index_spree_addresses_on_state_id", using: :btree

  create_table "spree_adjustments", force: :cascade do |t|
    t.integer  "source_id"
    t.decimal  "amount",                      precision: 8, scale: 2
    t.string   "label",           limit: 255
    t.string   "source_type",     limit: 255
    t.integer  "adjustable_id"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.boolean  "mandatory"
    t.boolean  "eligible",                                            default: true
    t.string   "adjustable_type", limit: 255
    t.string   "state"
    t.integer  "order_id"
    t.boolean  "included",                                            default: false
  end

  add_index "spree_adjustments", ["adjustable_id", "adjustable_type"], name: "idx_spree_adjustments_index_spree_adjustments_on_adjustable_3", using: :btree
  add_index "spree_adjustments", ["adjustable_id"], name: "idx_spree_adjustments_index_adjustments_on_order_id", using: :btree
  add_index "spree_adjustments", ["eligible"], name: "index_spree_adjustments_on_eligible", using: :btree
  add_index "spree_adjustments", ["order_id"], name: "index_spree_adjustments_on_order_id", using: :btree
  add_index "spree_adjustments", ["source_id", "source_type"], name: "idx_spree_adjustments_index_spree_adjustments_on_source_id__4", using: :btree

  create_table "spree_assets", force: :cascade do |t|
    t.integer  "viewable_id"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.integer  "position"
    t.string   "viewable_type",           limit: 50
    t.string   "attachment_content_type", limit: 255
    t.string   "attachment_file_name",    limit: 255
    t.string   "type",                    limit: 75
    t.datetime "attachment_updated_at"
    t.text     "alt"
    t.boolean  "search_result_asset",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_assets", ["viewable_id"], name: "idx_spree_assets_index_assets_on_viewable_id", using: :btree
  add_index "spree_assets", ["viewable_type", "type"], name: "idx_spree_assets_index_assets_on_viewable_type_and_type", using: :btree

  create_table "spree_backgrounds", force: :cascade do |t|
    t.integer  "position"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "taxon_id"
  end

  add_index "spree_backgrounds", ["taxon_id"], name: "index_spree_backgrounds_on_taxon_id", using: :btree

  create_table "spree_calculators", force: :cascade do |t|
    t.string   "type",            limit: 255
    t.integer  "calculable_id",               null: false
    t.string   "calculable_type", limit: 255, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "preferences"
    t.datetime "deleted_at"
  end

  add_index "spree_calculators", ["calculable_id", "calculable_type"], name: "idx_spree_calculators_index_spree_calculators_on_calculable_6", using: :btree
  add_index "spree_calculators", ["deleted_at"], name: "index_spree_calculators_on_deleted_at", using: :btree
  add_index "spree_calculators", ["id", "type"], name: "idx_spree_calculators_index_spree_calculators_on_id_and_type", using: :btree

  create_table "spree_countries", force: :cascade do |t|
    t.string   "iso_name",        limit: 255
    t.string   "iso",             limit: 255
    t.string   "iso3",            limit: 255
    t.string   "name",            limit: 255
    t.integer  "numcode"
    t.boolean  "states_required",             default: false
    t.datetime "updated_at"
  end

  create_table "spree_credit_cards", force: :cascade do |t|
    t.string   "month",                       limit: 255
    t.string   "year",                        limit: 255
    t.string   "cc_type",                     limit: 255
    t.string   "last_digits",                 limit: 255
    t.integer  "address_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "gateway_customer_profile_id", limit: 255
    t.string   "gateway_payment_profile_id",  limit: 255
    t.string   "name"
    t.integer  "user_id"
    t.integer  "payment_method_id"
    t.boolean  "default",                                 default: false, null: false
  end

  add_index "spree_credit_cards", ["address_id"], name: "index_spree_credit_cards_on_address_id", using: :btree
  add_index "spree_credit_cards", ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id", using: :btree
  add_index "spree_credit_cards", ["user_id"], name: "index_spree_credit_cards_on_user_id", using: :btree

  create_table "spree_customer_returns", force: :cascade do |t|
    t.string   "number"
    t.integer  "stock_location_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "spree_favorites", force: :cascade do |t|
    t.integer  "favorable_id"
    t.string   "favorable_type"
    t.integer  "user_id"
    t.string   "guest_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_favorites", ["favorable_id", "favorable_type"], name: "index_spree_favorites_on_favorable_id_and_favorable_type", using: :btree
  add_index "spree_favorites", ["guest_token"], name: "index_spree_favorites_on_guest_token", using: :btree
  add_index "spree_favorites", ["user_id"], name: "index_spree_favorites_on_user_id", using: :btree

  create_table "spree_gateways", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.string   "name",        limit: 255
    t.text     "description"
    t.boolean  "active",                  default: true
    t.string   "environment", limit: 255, default: "development"
    t.string   "server",      limit: 255, default: "test"
    t.boolean  "test_mode",               default: true
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.text     "preferences"
  end

  add_index "spree_gateways", ["active"], name: "index_spree_gateways_on_active", using: :btree
  add_index "spree_gateways", ["test_mode"], name: "index_spree_gateways_on_test_mode", using: :btree

  create_table "spree_impression_brands", force: :cascade do |t|
    t.integer  "impression_id"
    t.integer  "brand_id"
    t.integer  "position"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "spree_impression_brands", ["brand_id"], name: "idx_spree_impression_brands_index_spree_impression_brands_o_8", using: :btree
  add_index "spree_impression_brands", ["impression_id"], name: "idx_spree_impression_brands_index_spree_impression_brands_o_9", using: :btree

  create_table "spree_impressions", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "sub_title",   limit: 255
    t.integer  "position"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "spree_inventory_units", force: :cascade do |t|
    t.string   "state",        limit: 255
    t.integer  "variant_id"
    t.integer  "order_id"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.integer  "shipment_id"
    t.boolean  "pending",                                           default: true
    t.integer  "line_item_id"
    t.decimal  "quantity",                 precision: 10, scale: 2, default: 1.0
  end

  add_index "spree_inventory_units", ["line_item_id"], name: "index_spree_inventory_units_on_line_item_id", using: :btree
  add_index "spree_inventory_units", ["order_id"], name: "idx_spree_inventory_units_index_inventory_units_on_order_id", using: :btree
  add_index "spree_inventory_units", ["shipment_id"], name: "idx_spree_inventory_units_index_inventory_units_on_shipment_id", using: :btree
  add_index "spree_inventory_units", ["variant_id"], name: "idx_spree_inventory_units_index_inventory_units_on_variant_id", using: :btree

  create_table "spree_line_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "variant_id"
    t.decimal  "quantity",             precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "price",                precision: 8,  scale: 2,               null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "currency"
    t.decimal  "cost_price",           precision: 10, scale: 2
    t.integer  "tax_category_id"
    t.decimal  "adjustment_total",     precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total", precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",          precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",   precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "pre_tax_amount",       precision: 12, scale: 4, default: 0.0, null: false
  end

  add_index "spree_line_items", ["order_id"], name: "idx_spree_line_items_index_spree_line_items_on_order_id", using: :btree
  add_index "spree_line_items", ["tax_category_id"], name: "index_spree_line_items_on_tax_category_id", using: :btree
  add_index "spree_line_items", ["variant_id"], name: "idx_spree_line_items_index_spree_line_items_on_variant_id", using: :btree

  create_table "spree_log_entries", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "source_type", limit: 255
    t.text     "details"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "spree_log_entries", ["source_id", "source_type"], name: "idx_spree_log_entries_index_spree_log_entries_on_source_id__11", using: :btree

  create_table "spree_option_types", force: :cascade do |t|
    t.string   "name",            limit: 100
    t.string   "presentation",    limit: 100
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "position",                    default: 0,     null: false
    t.boolean  "as_color_filter",             default: false
  end

  add_index "spree_option_types", ["position"], name: "index_spree_option_types_on_position", using: :btree

  create_table "spree_option_types_prototypes", id: false, force: :cascade do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
  end

  add_index "spree_option_types_prototypes", ["option_type_id", "prototype_id"], name: "idx_spree_option_types_prototypes_idx_opt_proto_on_opt_id_a_12", using: :btree
  add_index "spree_option_types_prototypes", ["prototype_id", "option_type_id"], name: "idx_spree_option_types_prototypes_idx_opt_proto_on_proto_id_13", using: :btree

  create_table "spree_option_values", force: :cascade do |t|
    t.integer  "position"
    t.string   "name",               limit: 255
    t.string   "presentation",       limit: 255
    t.integer  "option_type_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "spree_option_values", ["option_type_id"], name: "idx_spree_option_values_index_spree_option_values_on_option_14", using: :btree
  add_index "spree_option_values", ["position"], name: "index_spree_option_values_on_position", using: :btree

  create_table "spree_option_values_variants", id: false, force: :cascade do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "spree_option_values_variants", ["option_value_id", "variant_id"], name: "idx_spree_option_values_variants_idx_optval_on_optval_id_an_17", using: :btree
  add_index "spree_option_values_variants", ["variant_id", "option_value_id"], name: "idx_spree_option_values_variants_index_option_values_varian_15", using: :btree
  add_index "spree_option_values_variants", ["variant_id"], name: "idx_spree_option_values_variants_index_spree_option_values__16", using: :btree

  create_table "spree_orders", force: :cascade do |t|
    t.string   "number",                 limit: 15
    t.decimal  "item_total",                         precision: 8,  scale: 2, default: 0.0,     null: false
    t.decimal  "total",                              precision: 8,  scale: 2, default: 0.0,     null: false
    t.string   "state",                  limit: 255
    t.decimal  "adjustment_total",                   precision: 8,  scale: 2, default: 0.0,     null: false
    t.integer  "user_id"
    t.datetime "created_at",                                                                    null: false
    t.datetime "updated_at",                                                                    null: false
    t.datetime "completed_at"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.decimal  "payment_total",                      precision: 8,  scale: 2, default: 0.0
    t.integer  "shipping_method_id"
    t.string   "shipment_state",         limit: 255
    t.string   "payment_state",          limit: 255
    t.string   "email",                  limit: 255
    t.text     "special_instructions"
    t.string   "currency"
    t.string   "last_ip_address"
    t.integer  "created_by_id"
    t.decimal  "shipment_total",                     precision: 10, scale: 2, default: 0.0,     null: false
    t.decimal  "additional_tax_total",               precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                        precision: 10, scale: 2, default: 0.0
    t.string   "channel",                                                     default: "spree"
    t.decimal  "included_tax_total",                 precision: 10, scale: 2, default: 0.0,     null: false
    t.decimal  "item_count",                         precision: 10, scale: 2, default: 0.0
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.boolean  "confirmation_delivered",                                      default: false
    t.boolean  "considered_risky",                                            default: false
    t.string   "guest_token"
    t.datetime "canceled_at"
    t.integer  "canceler_id"
    t.integer  "store_id"
    t.integer  "state_lock_version",                                          default: 0,       null: false
  end

  add_index "spree_orders", ["approver_id"], name: "index_spree_orders_on_approver_id", using: :btree
  add_index "spree_orders", ["bill_address_id"], name: "idx_spree_orders_index_spree_orders_on_bill_address_id", using: :btree
  add_index "spree_orders", ["completed_at"], name: "index_spree_orders_on_completed_at", using: :btree
  add_index "spree_orders", ["confirmation_delivered"], name: "index_spree_orders_on_confirmation_delivered", using: :btree
  add_index "spree_orders", ["considered_risky"], name: "index_spree_orders_on_considered_risky", using: :btree
  add_index "spree_orders", ["created_by_id"], name: "index_spree_orders_on_created_by_id", using: :btree
  add_index "spree_orders", ["guest_token"], name: "index_spree_orders_on_guest_token", using: :btree
  add_index "spree_orders", ["number"], name: "idx_spree_orders_index_spree_orders_on_number", using: :btree
  add_index "spree_orders", ["ship_address_id"], name: "idx_spree_orders_index_spree_orders_on_ship_address_id", using: :btree
  add_index "spree_orders", ["shipping_method_id"], name: "idx_spree_orders_index_spree_orders_on_shipping_method_id", using: :btree
  add_index "spree_orders", ["user_id", "created_by_id"], name: "index_spree_orders_on_user_id_and_created_by_id", using: :btree
  add_index "spree_orders", ["user_id"], name: "idx_spree_orders_index_spree_orders_on_user_id", using: :btree

  create_table "spree_orders_promotions", id: false, force: :cascade do |t|
    t.integer "order_id"
    t.integer "promotion_id"
  end

  add_index "spree_orders_promotions", ["order_id", "promotion_id"], name: "index_spree_orders_promotions_on_order_id_and_promotion_id", using: :btree

  create_table "spree_pages", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.text     "body"
    t.string   "slug",                     limit: 255
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "show_in_header",                       default: false, null: false
    t.boolean  "show_in_footer",                       default: false, null: false
    t.string   "foreign_link",             limit: 255
    t.integer  "position",                             default: 1,     null: false
    t.boolean  "visible",                              default: true
    t.string   "meta_keywords",            limit: 255
    t.string   "meta_description",         limit: 255
    t.string   "layout",                   limit: 255
    t.boolean  "show_in_sidebar",                      default: false, null: false
    t.string   "meta_title",               limit: 255
    t.boolean  "render_layout_as_partial",             default: false
  end

  add_index "spree_pages", ["slug"], name: "idx_spree_pages_index_pages_on_slug", using: :btree

  create_table "spree_pages_stores", id: false, force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_pages_stores", ["page_id"], name: "index_spree_pages_stores_on_page_id", using: :btree
  add_index "spree_pages_stores", ["store_id"], name: "index_spree_pages_stores_on_store_id", using: :btree

  create_table "spree_payment_capture_events", force: :cascade do |t|
    t.decimal  "amount",     precision: 10, scale: 2, default: 0.0
    t.integer  "payment_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "spree_payment_capture_events", ["payment_id"], name: "index_spree_payment_capture_events_on_payment_id", using: :btree

  create_table "spree_payment_methods", force: :cascade do |t|
    t.string   "type",         limit: 255
    t.string   "name",         limit: 255
    t.text     "description"
    t.boolean  "active",                   default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.datetime "deleted_at"
    t.string   "display_on",   limit: 255
    t.boolean  "auto_capture"
    t.text     "preferences"
  end

  add_index "spree_payment_methods", ["id", "type"], name: "idx_spree_payment_methods_index_spree_payment_methods_on_id_18", using: :btree

  create_table "spree_payments", force: :cascade do |t|
    t.decimal  "amount",                           precision: 8, scale: 2, default: 0.0, null: false
    t.integer  "order_id"
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.integer  "source_id"
    t.string   "source_type",          limit: 255
    t.integer  "payment_method_id"
    t.string   "state",                limit: 255
    t.string   "response_code",        limit: 255
    t.string   "avs_response",         limit: 255
    t.string   "number"
    t.string   "cvv_response_code"
    t.string   "cvv_response_message"
  end

  add_index "spree_payments", ["order_id"], name: "idx_spree_payments_index_spree_payments_on_order_id", using: :btree
  add_index "spree_payments", ["payment_method_id"], name: "idx_spree_payments_index_spree_payments_on_payment_method_id", using: :btree
  add_index "spree_payments", ["source_id", "source_type"], name: "idx_spree_payments_index_spree_payments_on_source_id_and_so_19", using: :btree

  create_table "spree_preferences", force: :cascade do |t|
    t.text     "value"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "key",        limit: 255
  end

  add_index "spree_preferences", ["key"], name: "idx_spree_preferences_index_spree_preferences_on_key", unique: true, using: :btree

  create_table "spree_prices", force: :cascade do |t|
    t.integer  "variant_id",                          null: false
    t.decimal  "amount",     precision: 10, scale: 2
    t.string   "currency"
    t.datetime "deleted_at"
  end

  add_index "spree_prices", ["deleted_at"], name: "index_spree_prices_on_deleted_at", using: :btree
  add_index "spree_prices", ["variant_id", "currency"], name: "index_spree_prices_on_variant_id_and_currency", using: :btree

  create_table "spree_product_option_types", force: :cascade do |t|
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "spree_product_option_types", ["option_type_id"], name: "idx_spree_product_option_types_index_spree_product_option_t_23", using: :btree
  add_index "spree_product_option_types", ["position"], name: "index_spree_product_option_types_on_position", using: :btree
  add_index "spree_product_option_types", ["product_id"], name: "idx_spree_product_option_types_index_spree_product_option_t_22", using: :btree

  create_table "spree_product_properties", force: :cascade do |t|
    t.string   "value",       limit: 255
    t.integer  "product_id"
    t.integer  "property_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "position",                default: 0
  end

  add_index "spree_product_properties", ["position"], name: "index_spree_product_properties_on_position", using: :btree
  add_index "spree_product_properties", ["product_id"], name: "idx_spree_product_properties_index_product_properties_on_pr_24", using: :btree
  add_index "spree_product_properties", ["property_id"], name: "idx_spree_product_properties_index_spree_product_properties_25", using: :btree

  create_table "spree_products", force: :cascade do |t|
    t.string   "name",                   limit: 255, default: "",   null: false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "slug",                   limit: 255
    t.text     "meta_description"
    t.string   "meta_keywords",          limit: 255
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "pdf_file_file_name",     limit: 255
    t.string   "pdf_file_content_type",  limit: 255
    t.integer  "pdf_file_file_size"
    t.datetime "pdf_file_updated_at"
    t.string   "subtitle",               limit: 255
    t.boolean  "promotionable",                      default: true
    t.string   "meta_title"
    t.integer  "cached_favorites_count"
  end

  add_index "spree_products", ["available_on"], name: "idx_spree_products_index_spree_products_on_available_on", using: :btree
  add_index "spree_products", ["deleted_at"], name: "idx_spree_products_index_spree_products_on_deleted_at", using: :btree
  add_index "spree_products", ["name"], name: "idx_spree_products_index_spree_products_on_name", using: :btree
  add_index "spree_products", ["shipping_category_id"], name: "idx_spree_products_index_spree_products_on_shipping_category_id", using: :btree
  add_index "spree_products", ["slug"], name: "index_spree_products_on_slug", unique: true, using: :btree
  add_index "spree_products", ["tax_category_id"], name: "idx_spree_products_index_spree_products_on_tax_category_id", using: :btree

  create_table "spree_products_promotion_rules", id: false, force: :cascade do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_products_promotion_rules", ["product_id"], name: "idx_spree_products_promotion_rules_index_products_promotion_26", using: :btree
  add_index "spree_products_promotion_rules", ["promotion_rule_id", "product_id"], name: "idx_spree_products_promotion_rules_idx_prod_promo_on_promo__28", using: :btree
  add_index "spree_products_promotion_rules", ["promotion_rule_id"], name: "idx_spree_products_promotion_rules_index_products_promotion_27", using: :btree

  create_table "spree_products_taxons", id: false, force: :cascade do |t|
    t.integer "product_id"
    t.integer "taxon_id"
    t.integer "position"
  end

  add_index "spree_products_taxons", ["position"], name: "index_spree_products_taxons_on_position", using: :btree
  add_index "spree_products_taxons", ["product_id", "taxon_id"], name: "idx_spree_products_taxons_index_spree_products_taxons_on_pr_32", using: :btree
  add_index "spree_products_taxons", ["product_id"], name: "idx_spree_products_taxons_index_spree_products_taxons_on_pr_29", using: :btree
  add_index "spree_products_taxons", ["taxon_id", "product_id"], name: "idx_spree_products_taxons_index_spree_products_taxons_on_ta_31", using: :btree
  add_index "spree_products_taxons", ["taxon_id"], name: "idx_spree_products_taxons_index_spree_products_taxons_on_ta_30", using: :btree

  create_table "spree_promotion_action_line_items", force: :cascade do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.decimal "quantity",            precision: 10, scale: 2, default: 0.0
  end

  add_index "spree_promotion_action_line_items", ["promotion_action_id"], name: "idx_spree_promotion_action_line_items_index_spree_promotion_33", using: :btree
  add_index "spree_promotion_action_line_items", ["variant_id"], name: "idx_spree_promotion_action_line_items_index_spree_promotion_34", using: :btree

  create_table "spree_promotion_actions", force: :cascade do |t|
    t.integer  "position"
    t.string   "type",         limit: 255
    t.integer  "promotion_id"
    t.datetime "deleted_at"
  end

  add_index "spree_promotion_actions", ["deleted_at"], name: "index_spree_promotion_actions_on_deleted_at", using: :btree
  add_index "spree_promotion_actions", ["id", "type"], name: "idx_spree_promotion_actions_index_spree_promotion_actions_o_35", using: :btree
  add_index "spree_promotion_actions", ["promotion_id"], name: "index_spree_promotion_actions_on_promotion_id", using: :btree

  create_table "spree_promotion_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "spree_promotion_rules", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_group_id"
    t.string   "type",             limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "promotion_id"
    t.string   "code"
    t.text     "preferences"
  end

  add_index "spree_promotion_rules", ["id", "type"], name: "idx_spree_promotion_rules_index_spree_promotion_rules_on_id_38", using: :btree
  add_index "spree_promotion_rules", ["product_group_id"], name: "index_promotion_rules_on_product_group_id", using: :btree
  add_index "spree_promotion_rules", ["promotion_id"], name: "index_spree_promotion_rules_on_promotion_id", using: :btree
  add_index "spree_promotion_rules", ["user_id"], name: "idx_spree_promotion_rules_index_promotion_rules_on_user_id", using: :btree

  create_table "spree_promotion_rules_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_promotion_rules_users", ["promotion_rule_id"], name: "idx_spree_promotion_rules_users_index_promotion_rules_users_41", using: :btree
  add_index "spree_promotion_rules_users", ["user_id"], name: "idx_spree_promotion_rules_users_index_promotion_rules_users_40", using: :btree

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

  create_table "spree_properties", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "presentation", limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "spree_properties_prototypes", id: false, force: :cascade do |t|
    t.integer "prototype_id"
    t.integer "property_id"
  end

  add_index "spree_properties_prototypes", ["property_id", "prototype_id"], name: "idx_spree_properties_prototypes_idx_props_proto_on_prop_id__42", using: :btree
  add_index "spree_properties_prototypes", ["prototype_id", "property_id"], name: "idx_spree_properties_prototypes_idx_props_proto_on_proto_id_43", using: :btree

  create_table "spree_prototypes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

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

  create_table "spree_return_authorizations", force: :cascade do |t|
    t.string   "number",                         limit: 255
    t.string   "state",                          limit: 255
    t.integer  "order_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.text     "memo"
    t.integer  "stock_location_id"
    t.integer  "return_authorization_reason_id"
  end

  add_index "spree_return_authorizations", ["order_id"], name: "idx_spree_return_authorizations_index_spree_return_authoriz_44", using: :btree
  add_index "spree_return_authorizations", ["return_authorization_reason_id"], name: "index_return_authorizations_on_return_authorization_reason_id", using: :btree

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

  create_table "spree_roles", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "spree_roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "spree_roles_users", ["role_id"], name: "idx_spree_roles_users_index_spree_roles_users_on_role_id", using: :btree
  add_index "spree_roles_users", ["user_id"], name: "idx_spree_roles_users_index_spree_roles_users_on_user_id", using: :btree

  create_table "spree_shipments", force: :cascade do |t|
    t.string   "tracking",             limit: 255
    t.string   "number",               limit: 255
    t.decimal  "cost",                             precision: 8,  scale: 2
    t.datetime "shipped_at"
    t.integer  "order_id"
    t.integer  "address_id"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.string   "state",                limit: 255
    t.integer  "stock_location_id"
    t.decimal  "adjustment_total",                 precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total",             precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                      precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",               precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "pre_tax_amount",                   precision: 12, scale: 4, default: 0.0, null: false
  end

  add_index "spree_shipments", ["address_id"], name: "idx_spree_shipments_index_spree_shipments_on_address_id", using: :btree
  add_index "spree_shipments", ["number"], name: "idx_spree_shipments_index_shipments_on_number", using: :btree
  add_index "spree_shipments", ["order_id"], name: "idx_spree_shipments_index_spree_shipments_on_order_id", using: :btree
  add_index "spree_shipments", ["stock_location_id"], name: "index_spree_shipments_on_stock_location_id", using: :btree

  create_table "spree_shipping_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "spree_shipping_method_categories", force: :cascade do |t|
    t.integer  "shipping_method_id",   null: false
    t.integer  "shipping_category_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "spree_shipping_method_categories", ["shipping_category_id", "shipping_method_id"], name: "unique_spree_shipping_method_categories", unique: true, using: :btree
  add_index "spree_shipping_method_categories", ["shipping_method_id"], name: "index_spree_shipping_method_categories_on_shipping_method_id", using: :btree

  create_table "spree_shipping_methods", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "display_on",      limit: 255
    t.datetime "deleted_at"
    t.string   "tracking_url"
    t.string   "admin_name"
    t.integer  "tax_category_id"
    t.string   "code"
  end

  add_index "spree_shipping_methods", ["deleted_at"], name: "index_spree_shipping_methods_on_deleted_at", using: :btree
  add_index "spree_shipping_methods", ["tax_category_id"], name: "index_spree_shipping_methods_on_tax_category_id", using: :btree

  create_table "spree_shipping_methods_zones", id: false, force: :cascade do |t|
    t.integer "shipping_method_id"
    t.integer "zone_id"
  end

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

  create_table "spree_sliders", force: :cascade do |t|
    t.string   "url",                limit: 255
    t.string   "group_key",          limit: 255
    t.integer  "position"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "spree_state_changes", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "previous_state", limit: 255
    t.integer  "stateful_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "stateful_type",  limit: 255
    t.string   "next_state",     limit: 255
  end

  add_index "spree_state_changes", ["stateful_id", "stateful_type"], name: "idx_spree_state_changes_index_spree_state_changes_on_statef_47", using: :btree
  add_index "spree_state_changes", ["user_id"], name: "idx_spree_state_changes_index_spree_state_changes_on_user_id", using: :btree

  create_table "spree_states", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "abbr",       limit: 255
    t.integer  "country_id"
    t.datetime "updated_at"
  end

  add_index "spree_states", ["country_id"], name: "idx_spree_states_index_spree_states_on_country_id", using: :btree

  create_table "spree_stock_items", force: :cascade do |t|
    t.integer  "stock_location_id"
    t.integer  "variant_id"
    t.decimal  "count_on_hand",     precision: 10, scale: 2, default: 0.0,   null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.boolean  "backorderable",                              default: false
    t.datetime "deleted_at"
  end

  add_index "spree_stock_items", ["backorderable"], name: "index_spree_stock_items_on_backorderable", using: :btree
  add_index "spree_stock_items", ["deleted_at"], name: "index_spree_stock_items_on_deleted_at", using: :btree
  add_index "spree_stock_items", ["stock_location_id", "variant_id"], name: "stock_item_by_loc_and_var_id", using: :btree
  add_index "spree_stock_items", ["stock_location_id"], name: "index_spree_stock_items_on_stock_location_id", using: :btree
  add_index "spree_stock_items", ["variant_id"], name: "index_spree_stock_items_on_variant_id", using: :btree

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
    t.decimal  "quantity",        precision: 10, scale: 2, default: 0.0
    t.string   "action"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
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

  create_table "spree_tax_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "is_default",              default: false
    t.datetime "deleted_at"
    t.string   "tax_code"
  end

  add_index "spree_tax_categories", ["deleted_at"], name: "index_spree_tax_categories_on_deleted_at", using: :btree
  add_index "spree_tax_categories", ["is_default"], name: "index_spree_tax_categories_on_is_default", using: :btree

  create_table "spree_tax_rates", force: :cascade do |t|
    t.decimal  "amount",                         precision: 8, scale: 5
    t.integer  "zone_id"
    t.integer  "tax_category_id"
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.boolean  "included_in_price",                                      default: false
    t.string   "name",               limit: 255
    t.boolean  "show_rate_in_label",                                     default: true
    t.datetime "deleted_at"
  end

  add_index "spree_tax_rates", ["deleted_at"], name: "index_spree_tax_rates_on_deleted_at", using: :btree
  add_index "spree_tax_rates", ["included_in_price"], name: "index_spree_tax_rates_on_included_in_price", using: :btree
  add_index "spree_tax_rates", ["show_rate_in_label"], name: "index_spree_tax_rates_on_show_rate_in_label", using: :btree
  add_index "spree_tax_rates", ["tax_category_id"], name: "idx_spree_tax_rates_index_spree_tax_rates_on_tax_category_id", using: :btree
  add_index "spree_tax_rates", ["zone_id"], name: "idx_spree_tax_rates_index_spree_tax_rates_on_zone_id", using: :btree

  create_table "spree_taxonomies", force: :cascade do |t|
    t.string   "name",        limit: 255,                 null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "position",                default: 0
    t.boolean  "is_a_filter",             default: false
  end

  add_index "spree_taxonomies", ["position"], name: "index_spree_taxonomies_on_position", using: :btree

  create_table "spree_taxonomies_filters", id: false, force: :cascade do |t|
    t.integer "taxon_id"
    t.integer "taxonomy_id"
  end

  create_table "spree_taxons", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "position",                      default: 0
    t.string   "name",              limit: 255,                null: false
    t.string   "permalink",         limit: 255
    t.integer  "taxonomy_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name",    limit: 255
    t.string   "icon_content_type", limit: 255
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "depth"
    t.integer  "visibility",                    default: 1
    t.boolean  "enabled",                       default: true
  end

  add_index "spree_taxons", ["parent_id"], name: "idx_spree_taxons_index_taxons_on_parent_id", using: :btree
  add_index "spree_taxons", ["permalink"], name: "idx_spree_taxons_index_taxons_on_permalink", using: :btree
  add_index "spree_taxons", ["position"], name: "index_spree_taxons_on_position", using: :btree
  add_index "spree_taxons", ["taxonomy_id"], name: "idx_spree_taxons_index_taxons_on_taxonomy_id", using: :btree

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

  create_table "spree_trackers", force: :cascade do |t|
    t.string   "analytics_id", limit: 255
    t.boolean  "active",                   default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "spree_trackers", ["active"], name: "index_spree_trackers_on_active", using: :btree

  create_table "spree_users", force: :cascade do |t|
    t.string   "encrypted_password",     limit: 255
    t.string   "password_salt",          limit: 255
    t.string   "email",                  limit: 255
    t.string   "remember_token",         limit: 255
    t.string   "persistence_token",      limit: 255
    t.string   "reset_password_token",   limit: 255
    t.string   "perishable_token",       limit: 255
    t.integer  "sign_in_count",                      default: 0, null: false
    t.integer  "failed_attempts",                    default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "login",                  limit: 255
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "spree_api_key",          limit: 48
    t.string   "authentication_token",   limit: 255
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.datetime "deleted_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "cached_favorites_count"
  end

  add_index "spree_users", ["bill_address_id"], name: "idx_spree_users_index_spree_users_on_bill_address_id", using: :btree
  add_index "spree_users", ["deleted_at"], name: "index_spree_users_on_deleted_at", using: :btree
  add_index "spree_users", ["email"], name: "idx_spree_users_email_idx_unique", unique: true, using: :btree
  add_index "spree_users", ["persistence_token"], name: "idx_spree_users_index_users_on_persistence_token", using: :btree
  add_index "spree_users", ["ship_address_id"], name: "idx_spree_users_index_spree_users_on_ship_address_id", using: :btree
  add_index "spree_users", ["spree_api_key"], name: "index_spree_users_on_spree_api_key", using: :btree

  create_table "spree_variants", force: :cascade do |t|
    t.string   "sku",               limit: 255,                         default: "",    null: false
    t.decimal  "weight",                        precision: 8, scale: 2
    t.decimal  "height",                        precision: 8, scale: 2
    t.decimal  "width",                         precision: 8, scale: 2
    t.decimal  "depth",                         precision: 8, scale: 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                             default: false
    t.integer  "product_id"
    t.decimal  "cost_price",                    precision: 8, scale: 2
    t.integer  "position"
    t.integer  "repeat"
    t.string   "cost_currency"
    t.boolean  "track_inventory",                                       default: true
    t.integer  "tax_category_id"
    t.datetime "updated_at"
    t.integer  "stock_items_count",                                     default: 0,     null: false
  end

  add_index "spree_variants", ["deleted_at"], name: "index_spree_variants_on_deleted_at", using: :btree
  add_index "spree_variants", ["is_master"], name: "index_spree_variants_on_is_master", using: :btree
  add_index "spree_variants", ["position"], name: "index_spree_variants_on_position", using: :btree
  add_index "spree_variants", ["product_id"], name: "index_spree_variants_on_product_id", using: :btree
  add_index "spree_variants", ["sku"], name: "index_spree_variants_on_sku", using: :btree
  add_index "spree_variants", ["tax_category_id"], name: "index_spree_variants_on_tax_category_id", using: :btree
  add_index "spree_variants", ["track_inventory"], name: "index_spree_variants_on_track_inventory", using: :btree

  create_table "spree_zone_members", force: :cascade do |t|
    t.integer  "zoneable_id"
    t.string   "zoneable_type", limit: 255
    t.integer  "zone_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "spree_zone_members", ["zone_id"], name: "idx_spree_zone_members_index_spree_zone_members_on_zone_id", using: :btree
  add_index "spree_zone_members", ["zoneable_id", "zoneable_type"], name: "idx_spree_zone_members_index_spree_zone_members_on_zoneable_48", using: :btree

  create_table "spree_zones", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "description",        limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "default_tax",                    default: false
    t.integer  "zone_members_count",             default: 0
    t.boolean  "for_popup",                      default: false
    t.string   "kind"
  end

  add_index "spree_zones", ["default_tax"], name: "index_spree_zones_on_default_tax", using: :btree
  add_index "spree_zones", ["kind"], name: "index_spree_zones_on_kind", using: :btree

end
