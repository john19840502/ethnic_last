module Spree
  module Admin
    class ProductOptionTypesController < Spree::Admin::BaseController
      respond_to :html

      def index
        @product = Spree::Product.find_by_slug(params[:product_id])
        @product_option_types = @product.product_option_types.order(:position).all

        params[:q] ||= {}
        params[:q][:s] ||= "name asc"

        @search = Spree::OptionType.ransack(params[:q])
        @option_types = @search.result.page(params[:page]).per(25)
      end

      def destroy
        product_option_type = Spree::ProductOptionType.find(params[:id])
        product_option_type.destroy
        render :text => nil
      end

      def create
        option_type = Spree::OptionType.find(params[:option_type_id])
        @product = Spree::Product.find_by_slug(params[:product_id])
        Spree::ProductOptionType.create!(option_type: option_type, product: @product)
        redirect_to admin_product_product_option_types_url(@product)
      end

    end
  end
end
