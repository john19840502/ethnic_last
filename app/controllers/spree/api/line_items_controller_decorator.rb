Spree::Api::LineItemsController.class_eval do
	def line_items_attributes
    {line_items_attributes: {
        id: params[:id],
        quantity: params[:line_item][:quantity],
        price: params[:line_item][:price],
        options: line_item_params[:options] || {}
    }}
  end
end
