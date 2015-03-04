Spree::CheckoutController.class_eval do
  #include Spree::ProductsHelper
  helper 'spree/products'
end