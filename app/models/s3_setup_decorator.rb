if Rails.env == 'production'

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

      path:           '/:class/:id/:style/:basename.:extension',
      default_url:    '/:class/:id/:style/:basename.:extension',
      default_style:  'product'
  }

  attachment_config.each do |key, value|
    Spree::Slider.attachment_definitions[:image][key.to_sym] = value
    Spree::Taxon.attachment_definitions[:icon][key.to_sym] = value
    Spree::Background.attachment_definitions[:image][key.to_sym] = value
    Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
    Spree::Product.attachment_definitions[:pdf_file][key.to_sym] = value
  end
end
