require 'application_responder'
require 'spree/search'
Spree::ProductsController.class_eval do

  def accurate_title
    @product ? @product.meta_description : super
  end
  
  def index
    @searcher = Spree::Config.searcher_class.new(params.merge(search: [[:brand_search, params[:keywords]]], currency: current_currency))
    # @searcher = Search.new(params.merge(search: [[:brand_search, params[:keywords]]]))
    @searcher.current_user = try_spree_current_user
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)
    if params[:page].present?
      render partial: 'spree/shared/products_list', locals: { products: @products}
    else
      respond_with(@products)
    end
  end
end
