Spree::Shipment.class_eval do
  def set_up_inventory(state, variant, order, line_item, quantity)
    self.inventory_units.create(
        state: state,
        variant_id: variant.id,
        order_id: order.id,
        line_item_id: line_item.id,
        quantity: quantity
    ) if quantity > 0
  end

  ManifestItem = Struct.new(:line_item, :variant, :quantity, :states)

  def manifest
    # Grouping by the ID means that we don't have to call out to the association accessor
    # This makes the grouping by faster because it results in less SQL cache hits.
    inventory_units.group_by(&:variant_id).map do |variant_id, units|
      units.group_by(&:line_item_id).map do |line_item_id, units|

        states = {}
        units.group_by(&:state).each { |state, iu| states[state] = iu.sum(&:quantity) }

        line_item = units.first.line_item
        variant = units.first.variant
        quantity = 0
        units.each{|unit| quantity += unit.quantity }
        ManifestItem.new(line_item, variant, quantity, states)
      end
    end.flatten
  end
end