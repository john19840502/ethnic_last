Spree::CheckoutController.class_eval do
  helper 'spree/products'

  def pay_with_mollie
    #debugger
    if (params[:state] == 'select_payment_method')
      @order[:payment_state] = params[:which_payment] || 1
    end
    return unless params[:state] == 'payment'
    if params[:order][:payments_attributes] != nil
      pm_id = params[:order][:payments_attributes].first[:payment_method_id]
      payment_method = Spree::PaymentMethod.find(pm_id)
      
      if payment_method 
      	if payment_method.is_a?(Spree::PaymentMethod::Mollie)
  	      status_object = MolliePaymentService.new(payment_method: payment_method,
  	                                               order: @order,
  	                                               method: params[:order][:payments_attributes].first[:mollie_method_id],
  	                                               issuer: params[:order][:payments_attributes].first[:issuer_id],
  	                                               redirect_url: mollie_check_status_url(@order)).create_payment
  	      if status_object.mollie_error?
  	        mollie_error && return
  	      end

  	      if status_object.has_error?
  	        flash[:error] = status_object.errors.join("\n")
  	        redirect_to checkout_state_path(@order.state) && return
  	      end
          #debugger
  	      redirect_to status_object.payment_url
    		end
      end
    end
  end

  def update
    #debugger
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      @order.temporary_address = !params[:save_user_address]
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to(checkout_state_path(@order.state)) && return
      end

      if @order.completed?
        @current_order = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end

end
