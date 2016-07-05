# if Rails.env == 'production'
  Rails.configuration.after_initialize do

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

        path: '/:class/:id/:style/:basename.:extension',
        default_url: '/:class/:id/:style/:basename.:extension'
    }

    attachment_config.each do |key, value|
      Spree::Slider.attachment_definitions[:image][key.to_sym] = value
      Spree::Taxon.attachment_definitions[:icon][key.to_sym] = value
      Spree::Background.attachment_definitions[:image][key.to_sym] = value
      Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
      Spree::Product.attachment_definitions[:pdf_file][key.to_sym] = value
      CollectionImage.attachment_definitions[:attachment][key.to_sym] = value
      Spree::OptionValue.attachment_definitions[:image][key.to_sym] = value
    end

    CollectionImage.attachment_definitions[:attachment][:path] = '/spree/collection_images/:id/:style/:basename.:extension'
    CollectionImage.attachment_definitions[:attachment][:default_url] = '/spree/collection_images/:id/:style/:basename.:extension'

    Spree::Image.attachment_definitions[:attachment][:path] = '/spree/products/:id/:style/:basename.:extension'
    Spree::Image.attachment_definitions[:attachment][:default_url] = '/spree/products/:id/:style/:basename.:extension'

    Spree::Product.attachment_definitions[:pdf_file][:path] = 'spree/product_pdf_files/:id/:style/:basename.:extension'
    Spree::Product.attachment_definitions[:pdf_file][:default_url] = 'spree/product_pdf_files/:id/:style/:basename.:extension'

    Spree::OptionValue.attachment_definitions[:image][:path] = '/spree/option_values/:id/:style/:basename.:extension'
    Spree::OptionValue.attachment_definitions[:image][:default_url] = '/spree/option_values/:id/:style/:basename.:extension'

  end
# end
