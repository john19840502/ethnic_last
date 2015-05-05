module Spree
  class SearchController < BaseController

    def do_search

      filters = JSON.parse(params[:filters]) if params[:filters].present?
      keywords = params[:keywords] if params[:keywords].present?
      remove_filter = JSON.parse(params[:remove_filter]) if params[:remove_filter].present?

      filter_parts = []
      filters["filters"].each do |f|
        next if f == remove_filter
        filter_parts << f["facet"]
        filter_parts << f["value"]
      end
      if keywords.present?
        redirect_to "/search/#{filter_parts.join("/")}?keywords=#{keywords}"
      else
        redirect_to "/search/#{filter_parts.join("/")}"
      end
    end

    def result
      @searcher = Spree::Config.searcher_class.new(params.merge(currency: current_currency))
      @searcher.current_user = try_spree_current_user
      @products = @searcher.retrieve_products
    end

  end
end
