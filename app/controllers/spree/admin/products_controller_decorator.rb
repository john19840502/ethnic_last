Spree::Admin::ProductsController.class_eval do
  def generate_meta_keywords
    render js: "$('#product_meta_keywords').val('#{@product.generate_meta_keywords}')"
  end

  def generate_meta_description
    render js: "$('#product_meta_description').val('#{@product.generate_meta_description}')"
  end
end
