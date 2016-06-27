class ProductVariantColor < ActiveRecord::Base
  belongs_to :product
  belongs_to :variant, class_name: 'Spree::Variant', foreign_key: 'variant_id'
  belongs_to :option_value, class_name: 'Spree::OptionValue', foreign_key: 'option_value_id'
end
