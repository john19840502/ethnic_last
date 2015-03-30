class Spree::TaxonObserver < ActiveRecord::Observer
  def after_save(taxon)
    taxon.products.each do |product|
      product.generate_meta_tags
      product.index!
    end
  end
end