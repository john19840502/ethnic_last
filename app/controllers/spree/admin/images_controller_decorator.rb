Spree::Admin::ImagesController.class_eval do
  new_action.before :set_auto_alt_text

  def set_auto_alt_text
    if @product.brand_name.present?
      alt_text = "#{@product.brand_name} - #{@product.name}"
    else
      alt_text = @product.name
    end
    @object.alt = alt_text
  end
end
