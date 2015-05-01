module Spree
  class SearchController < BaseController

    def result
      @searcher = Spree::Config.searcher_class.new(params.merge(currency: current_currency))
      @searcher.current_user = try_spree_current_user
      @products = @searcher.retrieve_products
    end

  end
end
