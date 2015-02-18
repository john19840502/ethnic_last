module SpreeProductPdf
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_paths
        paths = self.superclass.source_paths
        paths << File.expand_path('../templates', __FILE__)
        paths.flatten
      end
      # def add_javascripts
      #   append_file 'app/assets/javascripts/store/all.js', "//= require store/spree_product_pdf\n"
      #   append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_product_pdf\n"
      # end
      #
      # def add_stylesheets
      #   inject_into_file 'app/assets/stylesheets/store/all.css', " *= require store/spree_product_pdf\n", :before => /\*\//, :verbose => true
      #   inject_into_file 'app/assets/stylesheets/admin/all.css', " *= require admin/spree_product_pdf\n", :before => /\*\//, :verbose => true
      # end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_product_pdf'
      end

      def run_migrations
         res = ask 'Would you like to run the migrations now? [Y/n]'
         if res == '' || res.downcase == 'y'
           run 'bundle exec rake db:migrate'
         else
           puts 'Skipping rake db:migrate, don\'t forget to run it!'
         end
      end

      def add_config_for_s3
        puts 'Create config for S3.'
        copy_file 'config_s3.yml.sample', 'config/config_s3.yml'
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

    path:           '/spree/:class/:id/:style/:basename.:extension',
    default_url:    '/spree/:class/:id/:style/:basename.:extension',
    default_style:  'product'
}
Rails.configuration.to_prepare do
  if Rails.env == 'production'
    attachment_config.each do |key, value|
      Spree::Product.attachment_definitions[:pdf_file][:path] = '/spree/product_pdf_files/:id/:style/:basename.:extension'
      Spree::Product.attachment_definitions[:pdf_file][:url] = ':s3_eu_url'
    end
  else
    Spree::Product.attachment_definitions[:pdf_file][:path]= "\#{Rails.root}/public/spree/product_pdf_file/:id/:style/:basename.:extension"
    Spree::Product.attachment_definitions[:pdf_file][:url] = '/spree/product_pdf_file/:id/:style/:basename.:extension'
  end
end
          ]
        end
      end
    end
  end
end
