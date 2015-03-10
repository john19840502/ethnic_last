class Spree::TaxonObserver < ActiveRecord::Observer
  def after_save(taxon)
    taxon.products.each do |product|
      product.generate_meta_tags
    end
  end
end