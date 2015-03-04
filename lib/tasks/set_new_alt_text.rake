namespace :ethnicchic do
  task :update_alt_text, [:source] => :environment do |t, args|
    Spree::Product.find_each do |product|
      product.images.each do |image|
        taxons = ''
        product.taxons.each do |tax|
          taxons << tax.name.to_s
          taxons << ' '
        end
        image.update_attribute(:alt, "#{product.brand.name} - #{product.name} - #{taxons}")
      end
    end
  end
end