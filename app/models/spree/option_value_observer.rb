class Spree::OptionValueObserver < ActiveRecord::Observer
  def after_save(option_value)
    option_value.variants do |variant|
      variant.product.index!
    end
  end
end