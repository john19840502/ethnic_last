class Search
  attr_accessor :properties
  attr_accessor :current_user
  attr_accessor :current_currency

  def initialize(params)
    @properties = {}
    setup_search(params)
  end

  def retrieve_products
    @products = Spree::Product.algolia_search(keywords, { facets: '*', facetFilters: filters})
  end

  def method_missing(name)
    if @properties.has_key? name
      @properties[name]
    else
      super
    end
  end

  def facet_selected(facet)

  end

  protected
  def setup_search(params)
    @properties[:keywords] = params[:keywords] ||= ''
    filters = []
    if params[:filters].present?
      param_filters = params[:filters].split('/')
      (0...param_filters.length).step(2).each do |index|
        facet = param_filters[index]
        val = param_filters[index+1]
        filters << ("taxons.#{facet}:#{val}")
        @properties[:facets] = {facet: facet, value: val }
      end
    end
    @properties[:filters] = filters
  end

end
