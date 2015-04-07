Spree::Stock::AvailabilityValidator.class_eval do
  def validate(line_item)
    unit_count = line_item.inventory_units.to_a.sum(&:quantity)
    return if unit_count >= line_item.quantity
    quantity = line_item.quantity - unit_count

    quantifier = Spree::Stock::Quantifier.new(line_item.variant)

    unless quantifier.can_supply? quantity
      variant = line_item.variant
      display_name = %Q{#{variant.name}}
      display_name += %Q{ (#{variant.options_text})} unless variant.options_text.blank?

      line_item.errors[:quantity] << Spree.t(
          :selected_quantity_not_available,
          item: display_name.inspect
      )
    end
  end
end
