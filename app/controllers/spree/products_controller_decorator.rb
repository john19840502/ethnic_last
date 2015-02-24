Spree::ProductsController.class_eval do
  def accurate_title
    @product ? @product.meta_description : super
  end
  
  def index
    @searcher = Spree::Config.searcher_class.new(params)
    @searcher.current_user = try_spree_current_user
    @products = @searcher.retrieve_products
    if params[:page].present?
      render partial: 'spree/shared/products_list', locals: { products: @products}
    else
      respond_with(@products)do |format|
        format.html { render }
      end
    end
  end
end
