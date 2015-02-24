module Spree
	module Admin
		class InformationRequestsController < Spree::Admin::BaseController
		  respond_to :html
		  
		  def index
				@information_reqs = InformationRequest.all
		  end
		  
		  def show
				@information_req = InformationRequest.find_by_id(params[:id])
		  end
		end
	end
end
