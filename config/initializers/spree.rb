Spree.config do |config|
  config.currency = 'EUR'
  config.admin_products_per_page = 50
  config.track_inventory_levels = false

  nl_id = Spree::Country.where(iso: 'NL').try(:first).try(:id)
  config.default_country_id = nl_id unless nl_id.nil?
end

Spree.user_class = 'Spree::User'

attachment_config = {

    s3_credentials: {
        access_key_id:     ENV['AWS_ACCESS_KEY'],
        secret_access_key: ENV['AWS_SECRET'],
        bucket:            ENV['AWS_BUCKET']
    },

    storage:        :s3,
    s3_headers:     { 'Cache-Control' => 'max-age=31557600' },
    s3_protocol:    'https',
    bucket:         ENV['AWS_BUCKET'],
    url:            ':s3_domain_url',

    path:           '/spree/:class/:id/:style/:basename.:extension',
    default_url:    '/spree/:class/:id/:style/:basename.:extension',
    default_style:  'product'
}

Spree::Taxon.attachment_definitions[:icon][:styles] = { small: '100x100>' }
Spree::Background.attachment_definitions[:image][:styles] = { thumb: "100x100>" }

Spree::Slider.attachment_definitions[:image][:styles] = {
    mini:     '48x48>',
    small:    '100x100>',
    product:  '240x240>',
    large:    '600x600>'
}

Spree::Product.attachment_definitions[:pdf_file][:path] = '/spree/product_pdf_files/:id/:style/:basename.:extension'

if Rails.env == 'production'
  attachment_config.each do |key, value|
    Spree::Slider.attachment_definitions[:image][key.to_sym] = value
    Spree::Taxon.attachment_definitions[:icon][key.to_sym] = value
    Spree::Background.attachment_definitions[:image][key.to_sym] = value
    Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
    Spree::Product.attachment_definitions[:pdf_file][key.to_sym] = value
  end
end
