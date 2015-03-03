module Spree
	class InformationRequestsController < BaseController
	  respond_to :html
	  
	  def new
		@information_req = InformationRequest.new
	  end
	  
	  def create
			@information_req = InformationRequest.new(params[:information_request])
			if @information_req.save
				InformationRequestsMailer.information_request_email(@information_req).deliver
				respond_with(@information_req) { |format| format.html { redirect_to @information_req.product_url } }
			else
				@information_req
				render :new
			end
	  end
	end
end
