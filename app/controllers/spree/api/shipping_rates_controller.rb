module Spree
  module Api
    class ShippingRatesController < Spree::Api::BaseController
      include Spree::Core::ControllerHelpers::Order

      skip_before_action :check_for_user_or_api_key
      skip_before_action :authenticate_user
      before_action :load_order_with_lock

      def index

        @order.shipping_address = Spree::Address.build_default unless @order.shipping_address.present?

        @order.shipping_address.country = Spree::Country.find(params[:country_id])
        @order.shipping_address.save(validate: false)

        create_package_without_validations
        @rates = Spree::Stock::Estimator.new(@order).shipping_rates(@package)

        @currency = Spree::Config["currency"]

        respond_with(@rates)
      end

      private

        def load_order_with_lock
          @order = current_order(lock: true)
          respond_with(error: 'no_order') and return unless @order
        end

        def create_package_without_validations
          @order.adjustments.shipping.delete_all
          @order.shipments.destroy_all

          shipments = Spree::Stock::Coordinator.new(@order).shipments
          shipments.each { |shipment| shipment.save(validate: false) }
          @package = shipments.first.to_package
        end
    end
  end
end
