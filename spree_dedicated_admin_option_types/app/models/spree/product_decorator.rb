Spree::Product.class_eval do
  accepts_nested_attributes_for :product_option_types
end
