Spree::ProductsController.class_eval do

  def index
    # @searcher = build_searcher(params.merge(include_images: true, current_user: current_spree_user))
    # @products = @searcher.retrieve_products
    # @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

end
