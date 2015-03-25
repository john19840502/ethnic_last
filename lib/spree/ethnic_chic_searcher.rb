class EthnicChicSearcher < Spree::Core::Search::TaxonFilterSearcher

  def retrieve_products
    @products_scope = get_base_scope
    curr_page = page || 1

    @products = @products_scope.page(curr_page).per(per_page)
  end
  
  def initialize(params)
    super
		@properties[:brands] = Spree::Taxon.where("name in (?)", params[:brands]).map(&:id)
		if params["filters"].present?
			brands_root_id = Spree::Taxon.find_by_permalink('brands').try(:id)
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


    if @properties[:brands].present?
			# base_scope = base_scope.by_brands(@properties[:brands])
			base_scope = Spree::Product.algolia_search(keywords_algolia, facets: 'taxon_name', "facetFilters" => ["taxon_name:#{@properties[:brands].join(' & ')}",] )
		end
		if @properties[:price_range].present? and base_scope.present?
			price_range = @properties[:price_range].split(" - ")
			currency = @properties[:currency]
			base_scope = base_scope.joins(master: :prices).where('spree_prices.currency = ?', currency).
					where("spree_prices.amount>=? and spree_prices.amount<=? and spree_prices.amount is not null",price_range[0], price_range[1]) if price_range[1].to_i != 0
		end
		base_scope# = base_scope.available_to(current_user).order(:name)
  end
  
	# method should return new scope based on base_scope
  def get_products_conditions_for(base_scope, query)
		unless query.blank?
			base_scope = base_scope.like_any([:name], [query])
		end
		base_scope
  end
end
