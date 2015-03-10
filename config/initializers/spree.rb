Spree.config do |config|
  config.currency = 'EUR'
  config.admin_products_per_page = 50
  config.track_inventory_levels = false

  nl_id = Spree::Country.where(iso: 'NL').try(:first).try(:id)
  config.default_country_id = nl_id unless nl_id.nil?
end

Spree.user_class = 'Spree::User'
