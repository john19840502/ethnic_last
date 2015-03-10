Spree::Taxon.attachment_definitions[:icon][:styles] = { small: '100x100>' }

Spree::Taxon.class_eval do
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
end
