# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'

Spree.config do |config|
  config.currency = 'EUR'
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

if Rails.env == 'production'

  attachment_config.each do |key, value|
    Spree::Slider.attachment_definitions[:image][key.to_sym] = value
    Spree::Taxon.attachment_definitions[:icon][key.to_sym] = value
    Spree::Background.attachment_definitions[:image][key.to_sym] = value

    #Spree::Product.attachment_definitions[:pdf_file][:path] = '/spree/product_pdf_files/:id/:style/:basename.:extension'
  end
else
  Spree::Slider.attachment_definitions[:image][:path]= "#{Rails.root}/public/spree/sliders/:id/:style/:basename.:extension"
  Spree::Slider.attachment_definitions[:image][:url] = '/spree/sliders/:id/:style/:basename.:extension'

  # Spree::Product.attachment_definitions[:pdf_file][:path] = "#{Rails.root}/public/spree/product_pdf_files/:id/:style/:basename.:extension"
  # Spree::Product.attachment_definitions[:pdf_file][:url] = '/spree/product_pdf_files/:id/:style/:basename.:extension'

end
