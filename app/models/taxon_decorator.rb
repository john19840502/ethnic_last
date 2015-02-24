Spree::Taxon.class_eval do
  # Spree::Taxon.attachment_definitions[:icon][:path] = '/spree/taxons/:id/:style/:basename.:extension' if Spree::Config[:use_s3]
  # Spree::Taxon.attachment_definitions[:icon][:url] = ':s3_eu_url' if Spree::Config[:use_s3]
  
  def fetch_uniq_product_brands
	#Spree::Brand.where("id in (?)", self.products.map(&:brand_id).uniq).sort_by(&:name)
	Spree::Brand.joins(products: :taxons).where('spree_taxons.name= ?',self.name).active.uniq.sort_by(&:name)
  end
  
  def to_filter_params(params = {})
    filter_params = params['filters'].try(:dup) || []
    if(filter_params.include?(name.strip))
      filter_params.delete(name.strip)
    else
      filter_params << (Spree::Taxon.find(taxon_filter).name.strip)
    end
    filter_params.map {|f| "filters[]=#{f}"}.join('&')
  end
  
end
