class EthnicChicSearcher < Spree::Core::Search::TaxonFilterSearcher

  def retrieve_products
    @products_scope = get_base_scope
    curr_page = page || 1

    @products = Kaminari.paginate_array(@products_scope).page(curr_page).per(per_page)
  end
  
  def initialize(params)
    super
		@properties[:brands] = params[:brands]
		@properties[:colors] = params[:colors] if params[:colors]
		if params["filters"].present?
			brands_root_id = Spree::Taxon.find_by_permalink('brands').try(:name)
			@taxon_filters = Spree::Taxon.where("name in (?) and parent_id != ?", params["filters"], brands_root_id).map(&:id)
		else
			@taxon_filters = []
		end
		@properties[:taxon_filters] =  @taxon_filters
		if params[:price_range].present?
			@properties[:price_range] = params[:price_range]
		end
		if params[:currency].present?
			@properties[:currency] = params[:currency]
		end
  end

  def get_base_scope
		keywords_algolia = !keywords.nil? ? keywords : ''
		base_scope = Spree::Product.algolia_search(keywords_algolia)

		facets = []
    if @properties[:brands].present?
			brands = []
			@properties[:brands].each{|b| facets << "brand:#{b.gsub('?', '')}"}
			# facets << brands.join(',')
		end
		if @properties[:colors].present?
			colors = []
			@properties[:colors].each{|c| facets << "color_#{c}:true"}
			# facets << colors.join(',')
		end
		base_scope = Spree::Product.algolia_search(keywords_algolia,
																							 { facets: '*',
																								 facetFilters: facets})

		if @properties[:price_range].present? and base_scope.present?
			price_range = @properties[:price_range].split(" - ")
			currency = @properties[:currency]
			base_scope = base_scope.select {|product| product.master.prices.first.currency == currency}.
					select {|prod_with_curr| prod_with_curr.master.prices.first.amount.to_i >= price_range[0].to_i &&
						prod_with_curr.master.prices.first.amount.to_i <= price_range[1].to_i && !prod_with_curr.master.prices.first.amount.nil?
			} if price_range[1].to_i !=0
		end
		base_scope
  end
  
	# method should return new scope based on base_scope
  def get_products_conditions_for(base_scope, query)
		unless query.blank?
			base_scope = base_scope.like_any([:name], [query])
		end
		base_scope
  end
end
