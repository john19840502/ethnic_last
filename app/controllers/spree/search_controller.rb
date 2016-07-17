require 'uri'

module Spree
  class SearchController < BaseController

    def do_search
      filters = JSON.parse(params[:filters]) if params[:filters].present?
      keywords = params[:keywords] if params[:keywords].present?
      remove_filter = JSON.parse(params[:remove_filter]) if params[:remove_filter].present?
      previous_keywords = params[:previous_keywords] if params[:previous_keywords].present?

      filter_parts = []
      if filters != nil
        filters["filters"].each do |f|
            next if f == remove_filter
            filter_parts << f["facet"]
            filter_parts << f["value"]
          end
      end
      redirect_uri = "/search"
      if filter_parts.join("/") != ""
        redirect_uri = "/search/#{filter_parts.join("/")}"
      end
      page = params[:page] || 0
      search_keywords = keywords
      if (params[:search_in] == "2" && previous_keywords.present?)
        search_keywords = keywords + " " + previous_keywords
      end
      if search_keywords.present?
        search_params = {'keywords' => search_keywords}
        redirect_uri << "?#{search_params.to_query}"
      else
        redirect_uri << "?page=#{page}"
      end
      # if( (keywords and previous_keywords) and keywords != previous_keywords)
      #   redirect_uri = "/search?keywords=#{keywords}"
      # end
      # if (params[:search_in] == "2")
      #   keywords = keywords + " " + previous_keywords
      #   params = {'keywords' => keywords, 'page' => page}
      #   redirect_uri = "/search?#{params.to_query}"
      # end
      redirect_to URI.escape(redirect_uri)
    end

    def result
      debugger
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
