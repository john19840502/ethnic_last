# A rule to apply to an order greater than (or greater than or equal to)
# a specific amount
module Spree
  class Promotion
    module Rules
      class ItemQuantity < PromotionRule
        preference :min_quantity, :integer
        preference :max_quantity, :integer
        preference :operator1, :string, default: '>='
        preference :operator2, :string, default: '<='
		
        # attr_accessible :preferred_min_quantity, :preferred_max_quantity, :preferred_operator1, :preferred_operator2
		
        MIN_OPERATORS = ['gte']
        MAX_OPERATORS = ['lte']
		
        def eligible?(order, options = {})
          items_count = order.line_items.map(&:quantity).sum
          response = ( items_count >= preferred_min_quantity and items_count <= preferred_max_quantity ) ? true : false
          return response
        end
      end
    end
  end
end
