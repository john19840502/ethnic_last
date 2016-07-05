require 'uri'

module Spree
  class SearchController < BaseController

    def do_search
      filters = JSON.parse(params[:filters]) if params[:filters].present?
      keywords = params[:keywords] if params[:keywords].present?
      remove_filter = JSON.parse(params[:remove_filter]) if params[:remove_filter].present?
      if (params[:search_in] == "1")
        filters = nil
      end
      previous_keywords = params[:previous_keywords] if params[:previous_keywords].present?

      filter_parts = []
      if filters != nil
        filters["filters"].each do |f|
            next if f == remove_filter
            filter_parts << f["facet"]
            filter_parts << f["value"]
          end
      end
      redirect_uri = "/search/#{filter_parts.join("/")}"
      if keywords.present?
        redirect_uri = "/search/#{filter_parts.join("/")}?keywords=#{keywords}"
      end
      page = params[:page] || 0
      redirect_uri << "?page=#{page}"
      if( (keywords and previous_keywords) and keywords != previous_keywords)
        redirect_uri = "/search?keywords=#{keywords}"
      end
      redirect_to URI.escape(redirect_uri)
    end

    def result
      @searcher = Spree::Config.searcher_class.new(params.merge(currency: current_currency))
      @searcher.current_user = try_spree_current_user
      @products = @searcher.retrieve_products
      @page = @searcher.properties[:page]

      if (params["filters"] != nil)
        filters = params["filters"].split('/')
        taxons = []
        (0..filters.length / 2 - 1).each do |i|
          taxons << "taxons.#{filters[2*i].downcase}:#{filters[2*i+1].downcase}"
        end
        products = Spree::Product.algolia_search('', { facets: '*', facetFilters: taxons, hitsPerPage: 7 })
        @similar = products.select{ |prod| prod.images.first }
      end
      if (params[:filters] && params[:filters].split('/').first == 'brands')
        if (params[:filters] == 'brands/edward van vliet')
          params[:background_image] = 'edwardvavliet-background-LR9.0.jpg'
        else
          params[:background_image] = Spree::Background.where(taxon_id: products.first.brand.id).first
        end
      end
    end

    def brands_redirect
      brand = params[:brand_name]
      permalink = "brands/#{brand}"
      taxon = Spree::Taxon.find_by_permalink(permalink)
      if taxon
        return redirect_to URI.escape("/search/brands/#{taxon.name}"), :status => :moved_permanently
      else
        return redirect_to URI.escape("/search?keywords=#{brand.gsub('-',' ')}")
      end
    end


  end
end
