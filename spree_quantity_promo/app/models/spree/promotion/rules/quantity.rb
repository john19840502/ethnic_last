module Spree
  class Promotion
    module Rules
      class Quantity < PromotionRule
        preference :min, default: 0
        preference :max, default: 100

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          line_items_count = order.line_items.sum(:quantity)
          line_items_count >= preferred_min.to_i and line_items_count <= preferred_max.to_i
        end
      end
    end
  end
end
