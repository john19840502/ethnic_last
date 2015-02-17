module SpreeSlider
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_paths
        paths = self.superclass.source_paths
        paths << File.expand_path('../templates', __FILE__)
        paths.flatten
      end

      # def add_javascripts
      #   append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_slider\n"
      #   append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_slider\n"
      # end
      #
      # def add_stylesheets
      #   inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_slider\n", :before => /\*\//, :verbose => true
      #   inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_slider\n", :before => /\*\//, :verbose => true
      # end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_slider'
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
        puts 'Create config file for S3. Please, change the stubs into your S3 data'
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

    styles: {
        mini:     '48x48>',
        small:    '100x100>',
        product:  '240x240>',
        large:    '600x600>'
    },

    path:           '/spree/:class/:id/:style/:basename.:extension',
    default_url:    '/spree/:class/:id/:style/:basename.:extension',
    default_style:  'product'
}
if Rails.env == 'production'
  attachment_config.each do |key, value|
    Spree::Slider.attachment_definitions[:image][key.to_sym] = value
  end
  Paperclip.interpolates(:s3_eu_url) do |attachment, style|
    "\#{attachment.s3_protocol}://\#{Spree::Config[:s3_host_alias]}/\#{attachment.bucket_name}/\#{attachment.path(style).gsub(%r{^/}, '')}"
  end
else
  Spree::Slider.attachment_definitions[:image][:path]= "\#{Rails.root}/public/spree/products/:id/:style/:basename.:extension"
  Spree::Slider.attachment_definitions[:image][:url] = '/spree/products/:id/:style/:basename.:extension'
end
          ]
        end
      end
    end
  end
end
