class Spree::PricesObserver < ActiveRecord::Observer
  def after_save(price)
    price.variant.product.index!
  end
end