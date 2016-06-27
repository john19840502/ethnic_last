module Spree
	class InformationRequestsController < BaseController
	  respond_to :html

	  def new
			@information_req = InformationRequest.new
	  end

	  def create
			@information_req = InformationRequest.new(information_request_params)
			if @information_req.save
				Spree::InformationRequestMailer.information_request_email(@information_req).deliver
				respond_with(@information_req) { |format| format.html { redirect_to @information_req.product_url, notice: "Thank you for request for information, we will respond to you shortly" } }
			else
				@information_req
				render :new
			end
	  end

		private
		def information_request_params
			params.require(:information_request).permit(:product_url,:email,:name, :company, :address, :question)
		end
	end
end
