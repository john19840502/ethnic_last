Spree::Core::Importer::Order.class_eval do
  def self.create_shipments_from_params(shipments_hash, order)
    return [] unless shipments_hash

    inventory_units = Spree::Stock::InventoryUnitBuilder.new(order).units

    shipments_hash.each do |s|
      begin
        shipment = order.shipments.build
        shipment.tracking       = s[:tracking]
        shipment.stock_location = Spree::StockLocation.find_by_admin_name(s[:stock_location]) || Spree::StockLocation.find_by_name!(s[:stock_location])

        shipment_units = s[:inventory_units] || []

        shipment_units.each do |su|
          ensure_variant_id_from_params(su)
        end

        shipment_units_hash = Hash[shipment_units.group_by { |su| su }.map { |su, sus| [su, sus.length] }]

        shipment_units_hash.each do |shipment_unit_hash|
          su = shipment_unit_hash.first
          quantity = shipment_unit_hash.last
          inventory_unit = inventory_units.detect { |iu| iu.variant_id.to_i == su[:variant_id].to_i }

          if inventory_unit.present?
            if inventory_unit.quantity > quantity
              current_iu = inventory_unit.dup
              current_iu.quantity = quantity
              inventory_unit.quantity -= quantity
            else
              current_iu = inventory_unit

              # Don't assign shipments to this inventory unit more than once
              inventory_units.delete(inventory_unit)
            end
            current_iu.shipment = shipment

            if s[:shipped_at].present?
              current_iu.pending = false
              current_iu.state = 'shipped'
            end

            current_iu.save!
          end
        end

        if s[:shipped_at].present?
          shipment.shipped_at = s[:shipped_at]
          shipment.state      = 'shipped'
        end

        shipment.save!

        shipping_method = Spree::ShippingMethod.find_by_name(s[:shipping_method]) || Spree::ShippingMethod.find_by_admin_name!(s[:shipping_method])
        rate = shipment.shipping_rates.create!(shipping_method: shipping_method, cost: s[:cost])

        shipment.selected_shipping_rate_id = rate.id
        shipment.update_amounts

      rescue Exception => e
        raise "Order import shipments: #{e.message} #{s}"
      end
    end
  end
end