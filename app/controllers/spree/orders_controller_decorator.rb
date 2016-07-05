Spree::OrdersController.class_eval do
  before_action :go_back_to
  before_action :restrict_quantity, only: [:update]

  def update
    if flash[:error]
      redirect_back_or_default(spree.cart_path) and return
    else
      if @order.contents.update_cart(order_params)
        respond_with(@order) do |format|
          format.html do
            if params.has_key?(:checkout)
              @order.next if @order.cart?
              redirect_to checkout_state_path(@order.checkout_steps.first) and return
            else
              redirect_to cart_path and return
            end
          end
        end
      end
      respond_with(@order)
    end
  end

  def go_back_to
    if request.referer.present? && !request.referer.include?("cart")
      session[:go_back_to] = request.referer
    end
  end

  private
    def restrict_quantity
      order_params[:line_items_attributes].each_pair do |id, value|
        if value["quantity"].to_i > 100
          order_params[:line_items_attributes][id]["quantity"] = 100
          flash[:error] = Spree.t(:contact_us_for_stock_check)
        end
      end
    end
end
