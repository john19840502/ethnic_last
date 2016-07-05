require 'application_responder'
require 'spree/search'

Spree::ProductsController.class_eval do

  before_action :set_similar_products, only: [:show]

  def accurate_title
    @product ? @product.meta_description : super
  end

  def index
    @searcher = Spree::Config.searcher_class.new(params.merge(currency: current_currency))
    @searcher.current_user = try_spree_current_user
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)
    respond_with @products
  end

  def show
    @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
    @product_properties = @product.product_properties.includes(:property)
    @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if request.path != spree.product_path(@product)
      return redirect_to @product, :status => :moved_permanently
    end
  end

  def set_similar_products
    taxons = []
    @product.taxons.each do |t|
      taxons << "taxons.#{t.taxonomy.name.downcase}:#{t.name.downcase}"
    end
    # category_name = ""
    # @product.taxons.each do |t|
    #   if t.taxonomy.name.downcase == "categories"
    #     category_name = t.name.downcase
    #   end
    # end
    #debugger
    #products = Spree::Product.algolia_search('', { facets: [{:facet=>"categories", :value=>"#{category_name}"}], facetFilters: ["taxons.categories:#{category_name}"], hitsPerPage: 7 })
    products = Spree::Product.algolia_search('', { facets: '*', facetFilters: taxons, hitsPerPage: 7 })
    products.delete_if {|prod| prod.id == @product.id}
    @similar = products.select{ |prod| prod.images.first }
  end
end
