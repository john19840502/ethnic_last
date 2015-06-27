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

desc 'Reindex Products to Algolia'
task :reset_product_variant_colors => :environment do
  Spree::Product.available.find_each do |product|
    product.reset_variant_colors
  end
end
