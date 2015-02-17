module SpreeBrandsOnTaxons
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, :type => :boolean, :default => false

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_brands_on_taxons\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_brands_on_taxons\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_brands_on_taxons\n", :before => /\*\//, :verbose => true
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_brands_on_taxons\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_brands_on_taxons'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      def add_s3_config
        append_to_file 'config/initializers/spree.rb' do
          %Q[
config = YAML.load(File.read("\#{Rails.root}/config/config_s3.yml"))
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
          ]
        end
      end
    end
  end
end
