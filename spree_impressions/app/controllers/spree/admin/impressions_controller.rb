module Spree
  module Admin
    class ImpressionsController < ResourceController

      before_action :set_brand_taxonomy_id

      def update
        if params[:impression][:brand_ids].present?
          params[:impression][:brand_ids] = params[:impression][:brand_ids].split(',')
        end
        super
      end

      protected

      def collection
        @collection = Impression.page(params[:page]).per(Spree::Config[:admin_products_per_page])
      end

      private

      def set_brand_taxonomy_id
        @brand_taxonomy_id = Spree::Taxonomy.find_by_name('Brands').try(:id)
      end
    end
  end
end