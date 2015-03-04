namespace :ethnicchic do
  task :update_alt_text, [:source] => :environment do |t, args|
    Spree::Product.all.each do |product|
      product.images.each do |image|
        taxons = ''
        product.taxons.each do |tax|
          taxons << tax.name.to_s
          taxons << ' '
        end
        if image.update_attribute(:alt, "#{product.brand.name} - #{product.name} - #{taxons}")
          puts "#{product.brand.name} - #{product.name} - #{taxons}"
        end
      end
    end
  end
end