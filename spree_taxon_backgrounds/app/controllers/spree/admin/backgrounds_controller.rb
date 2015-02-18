module Spree
  module Admin
    class BackgroundsController < ResourceController
      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      protected

      def collection
        @collection = Background.page(params[:page]).per(Spree::Config[:admin_products_per_page])
      end
    end
  end
end