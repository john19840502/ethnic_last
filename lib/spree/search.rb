require 'uri'

class Search
  attr_accessor :properties
  attr_accessor :current_user
  attr_accessor :current_currency
  attr_accessor :page

  def initialize(params)
    @properties = {}
    setup_search(params)
  end

  def retrieve_products
    @products = Spree::Product.algolia_search(keywords,
      { facets: '*', facetFilters: filters, numericFilters: price_range, page: @properties[:page], hitsPerPage: 51 }
    )
  end

  def method_missing(name)
    if @properties.has_key? name
      @properties[name]
    else
      super
    end
  end

  def price_range
    if @properties[:price_range].present?
      price_range = @properties[:price_range].gsub("€","")
      price_range = price_range.gsub("$","")
      "prices: #{price_range}"
    else
      ''
    end
  end

  def display_facet?(facet)
    return false if facet == "prices"
    return false if facet == "colors"
    return false if facet == "brands"
    return false if facet == "categories" && facet_selected(facet)
    true
  end

  def brands_facets
    @properties[:facets].each do |f|
      return f[:facet] if f[:facet] == "brands"
    end
  end

  def selected_category
    @properties[:facets].each do |f|
      return f[:value] if f[:facet] == "categories"
    end
    nil
  end

  def selected_brand
    @properties[:facets].each do |f|
      return f[:value] if f[:facet] == "brands"
    end
    nil
  end

  def colors_facets
    @properties[:facets].each do |f|
      return f[:facet] if f[:facet] == "colors"
    end
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
        if facet == 'colors'
          filters << ("#{facet}:#{val}")
        else
          filters << ("taxons.#{facet}:#{val}")
        end
        @properties[:facets].push({ facet: facet, value: val })
      end
    end
    @properties[:filters] = filters
    @properties[:page] = params[:page] || 0

    if params[:price_range].present?
      range = params[:price_range].split('-')
      @properties[:price_range] = range.join(' to ')
    end
  end

end
