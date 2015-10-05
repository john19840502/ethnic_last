Spree::OrdersController.class_eval do
  before_action :go_back_to

  def go_back_to
    if request.referer.present? && !request.referer.include?("cart")
      session[:go_back_to] = request.referer
    end
  end
end
