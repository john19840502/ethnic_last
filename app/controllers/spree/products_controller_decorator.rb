require 'application_responder'
require 'spree/search'
Spree::ProductsController.class_eval do

  before_action :set_similar_products, only: [:show]

  def accurate_title
    @product ? @product.meta_description : super
  end

  def index
  end

  def set_similar_products
    category = @product.taxons.where(parent: Spree::Taxon.find_by_permalink('categories')).first
    products = Spree::Product.by_brands(@product.brand)
    products = products.filter_by(category.id) if category
    products = products.sample(6)

    @similar = products.select{ |prod| prod.images.first }
  end
end
