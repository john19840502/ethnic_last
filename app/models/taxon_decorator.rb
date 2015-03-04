Spree::Taxon.class_eval do
  after_save :generate_meta_tags
  
  def fetch_uniq_product_brands
  	Spree::Taxon.where('name= ?',self.name).active.uniq.sort_by(&:name)
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

  def self.active
    where(enabled: true)
  end

  def generate_meta_tags
    products = self.products
    products.each do |product|

      # Set meta keywords value
      meta_keywords = []
      meta_keywords << product.name
      meta_keywords << product.brand.try(:name)
      meta_keywords << product.taxons.map(&:name)
      meta_keywords = meta_keywords.flatten
      product.meta_keywords = meta_keywords.join(",")

      # Set meta description value
      meta_description = []
      meta_description << "#{product.brand.try(:name)} online shop #{product.name} #{product.tax_category.name}"
      taxons_name = product.taxons.map(&:name)
      taxons_name[taxons_name.index(taxons_name.last)] = "#{taxons_name.last} - worldwide shipping" if taxons_name.present?
      meta_description << taxons_name
      product.meta_description = meta_description.flatten.join(",")
      if product.save!
        puts meta_description.flatten.join(",")
      end
    end
  end
end
