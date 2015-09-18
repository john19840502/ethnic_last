Spree.config do |config|
  config.currency = 'EUR'
  config.admin_products_per_page = 50
  config.products_per_page = 50
  config.track_inventory_levels = false

  # nl_id = Spree::Country.where(iso: 'NL').try(:first).try(:id)
  # config.default_country_id = nl_id unless nl_id.nil?

  config.searcher_class = Search
end

Spree.user_class = 'Spree::User'
Money.add_rate("EUR", "USD", 1.10956)

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  html_tag
end
