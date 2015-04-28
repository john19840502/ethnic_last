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

  protected
  def setup_search(params)
    @properties[:keywords] = params[:keywords] ||= ''
    filters = []
    if params[:filters].present?
      param_filters = params[:filters].split('/')
      param_filters.each do |f|
        filters << "taxons.#{f}"
      end
    end
    @properties[:filters] = filters
  end

end
