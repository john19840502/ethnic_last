class EthnicChicSearcher < Spree::Core::Search::TaxonFilterSearcher

  def retrieve_products
    @products_scope = get_base_scope
    curr_page = page || 1

    @products = @products_scope.page(curr_page).per(per_page)
  end
  
  def initialize(params)
    super
    if params[:brand_id].present?
			@properties[:brand_id] = Spree::Brand.where("name in (?)", params[:brand_id]).map(&:id)
		else
			@properties[:brand_id] = Spree::Brand.where("name in (?)", params[:brands]).map(&:id)
		end
		@taxon_filters = params["filters"].present? ? Spree::Taxon.where("name in (?)", params["filters"]).map(&:id) : []
		@properties[:taxon_filters] =  @taxon_filters
		if params[:price_range].present?
			@properties[:price_range] = params[:price_range]
		end
  end

  def get_base_scope
    base_scope = super
    if @properties[:brand_id].present?
		base_scope = base_scope.by_brand(@properties[:brand_id])
		end
		if @properties[:price_range].present? and base_scope.present?
			price_range = @properties[:price_range].split(" - ")
			base_scope = base_scope.joins(:master).where("spree_variants.price>=? and spree_variants.price<=?",price_range[0], price_range[1]) if price_range[1].to_i != 0
		end
		base_scope = base_scope.with_active_brands(current_user).order(:name)
  end
  
	# method should return new scope based on base_scope
  def get_products_conditions_for(base_scope, query)
		unless query.blank?
			base_scope = base_scope.like_any([:name], [query])
		end
		base_scope
  end
end
