require 'uri'

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

      redirect_uri = "/search/#{filter_parts.join("/")}"
      if keywords.present?
        redirect_uri = "/search/#{filter_parts.join("/")}?keywords=#{keywords}"
      end
      page = params[:page] || 0
      redirect_uri << "?page=#{page}"
      redirect_to URI.escape(redirect_uri)
    end

    def result
      @searcher = Spree::Config.searcher_class.new(params.merge(currency: current_currency))
      @searcher.current_user = try_spree_current_user
      @products = @searcher.retrieve_products
      @page = @searcher.properties[:page]

      if request.xhr?
        to_paginate = @page.to_i == 0
        render :partial => 'spree/shared/products_list', :locals => { products: @products, page: @page, to_paginate: to_paginate }
      end

    end

  end
end
