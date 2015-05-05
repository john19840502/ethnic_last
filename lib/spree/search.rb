require 'uri'

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

  def display_facet?(facet)
    return false if facet == "prices"
    return false if facet == "color"
    return false if facet == "brands" && facet_selected(facet)
    return false if facet == "categories" && facet_selected(facet)
    true
  end

  def facet_and_value_selected(facet, value)
    @properties[:facets].each do |f|
      return true if f[:facet] == facet && f[:value] == value
    end
    return false
  end

  def facet_selected(facet)
    @properties[:facets].each do |f|
      return true if f[:facet] == facet
    end
    false
  end

  def json_filters
    hsh = { filters: @properties[:facets] }.to_json
  end

  def link_for_facet_value(facet, value)
    link_parts = []
    @properties[:facets].each do |f|
      link_parts << f[:facet]
      link_parts << f[:value]
    end
    link_parts << facet
    link_parts << value
    link = link_parts.join("/")
    if @properties[:keywords].present?
      link += "?keywords=#{keywords}"
    end
    URI.escape(link)
  end

  protected
  def setup_search(params)
    @properties[:facets] = []
    @properties[:keywords] = params[:keywords] ||= ''
    filters = []
    if params[:filters].present?
      param_filters = params[:filters].split('/')
      (0...param_filters.length).step(2).each do |index|
        facet = param_filters[index]
        val = param_filters[index+1]
        filters << ("taxons.#{facet}:#{val}")
        @properties[:facets].push({ facet: facet, value: val })
      end
    end
    @properties[:filters] = filters
  end

end
