# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'Reindex Products to Algolia'
task :reindex_products => :environment do
  Spree::Product.clear_index!
  Spree::Product.available.find_each do |product|
    product.index! if product.brand_enabled?
  end
end

desc 'Reset Variant Colors'
task :reset_product_variant_colors => :environment do
  Spree::Product.available.find_each do |product|
    product.reset_variant_colors
  end
end

desc 'reset product slug'
task :reset_slugs => :environment do
  Spree::Product.available.find_each do |product|
    if product.brand_enabled?
      product.slug = nil
      begin
        product.save!
      rescue
      end
    end
  end
end

desc 'generate meta content for products'
task :generate_meta_data => :environment do
  Spree::Product.find_each do |product|
    begin
      product.generate_meta_tags
    rescue
    end
  end
end

desc 'generate meta info for products'
task :generate_meta_info => :environment do
  Spree::Product.find_each do |product|
    begin
	  product.save!
	rescue
	end
  end
end 	
