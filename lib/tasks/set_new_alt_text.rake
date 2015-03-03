namespace :ethicchic do
  task :update_alt_text, [:source] => :environment do |t, args|
    Spree::Product.all.each do |product|
      product.images.each do |image|
        image.update_attribute(:alt, "#{product.brand.name} - #{product.name}")
      end
    end
  end
end