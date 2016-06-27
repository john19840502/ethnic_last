class Spree::Calculator::UpsExpressSaver < Spree::ShippingCalculator

  preference :min_weight_kg, :decimal, :default => 0
  preference :starting_price, :decimal, :default => 0
  preference :price_per_kg, :decimal, :default => 0
  preference :min_purchase_amount_for_free_shipping, :decimal

  def compute_package(object)
    return 0 if object.nil?

    package_weight = object.weight
    return 0 if package_weight == 0

    # make it in grams
    min_weight = preferred_min_weight_kg * 1000
    return preferred_starting_price if package_weight <= min_weight

    delta_grams = package_weight - min_weight
    factor = (delta_grams/1000.0).ceil

    if preferred_min_purchase_amount_for_free_shipping!=nil and preferred_min_purchase_amount_for_free_shipping!=0.0
	    if object.try("total")
	      if object.total>=preferred_min_purchase_amount_for_free_shipping
		      return 0
		    else
          return preferred_starting_price + (factor * preferred_price_per_kg)
        end
      elsif object.order.try("total")
	      if object.order.total>=preferred_min_purchase_amount_for_free_shipping
		      return 0
		    else
		      return preferred_starting_price + (factor * preferred_price_per_kg)
		    end
      else
		    return preferred_starting_price + (factor * preferred_price_per_kg)
	    end
	  else
	    return preferred_starting_price + (factor * preferred_price_per_kg)
	  end

  end

  def self.description
    "UPS Express Saver"
  end

  def self.service_name
    self.description
  end

  private

  def round_to_two_places(amount)
    BigDecimal.new(amount.to_s).round(2, BigDecimal::ROUND_HALF_UP)
  end
end
