class ProductVariantColor < ActiveRecord::Base
  belongs_to :product
  belongs_to :variant, class_name: 'Spree::Variant', foreign_key: 'variant_id'
end
