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
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
end

Spree.user_class = "Spree::User"

config = YAML.load(File.read("#{Rails.root}/config/config_s3.yml"))
attachment_config = {

    s3_credentials: {
        access_key_id:     config['aws_access_key_id'],
        secret_access_key: config['aws_secret_access_key'],
        bucket:            config['aws_bucket_name']
    },

    storage:        :s3,
    s3_headers:     { 'Cache-Control' => 'max-age=31557600' },
    s3_protocol:    'https',
    bucket:         config['aws_bucket_name'],
    url:            ':s3_domain_url',

    styles: {
        small:    '100x100>'
    },

    path:           '/spree/:class/:id/:style/:basename.:extension',
    default_url:    '/spree/:class/:id/:style/:basename.:extension',
    default_style:  'product'
}
if Rails.env == 'production'
  attachment_config.each do |key, value|
    Spree::Taxon.attachment_definitions[:icon][key.to_sym] = value
  end
end
          