Spree::Admin::ImagesController.class_eval do
  new_action.before :set_auto_alt_text

  def set_auto_alt_text
    @object.alt = "#{@product.brand.name} - #{@product.name}"
  end
end