Spree::OrdersController.class_eval do
  before_action :go_back_to

  def update
    begin
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
    rescue ActiveRecord::StatementInvalid
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    if error
      flash[:error] = error
      redirect_back_or_default(spree.cart_path)
    else
      respond_with(@order)
    end
  end

  def go_back_to
    if request.referer.present? && !request.referer.include?("cart")
      session[:go_back_to] = request.referer
    end
  end
end
