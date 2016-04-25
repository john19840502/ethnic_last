require 'uri'

module Spree
  class SearchController < BaseController

    def do_search

      filters = JSON.parse(params[:filters]) if params[:filters].present?
      keywords = params[:keywords] if params[:keywords].present?
      remove_filter = JSON.parse(params[:remove_filter]) if params[:remove_filter].present?

      previous_keywords = params[:previous_keywords] if params[:previous_keywords].present?

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
      #redirect_uri << "?page=#{page}"
      redirect_uri << "&page=#{page}"
      if( (keywords and previous_keywords) and keywords != previous_keywords)
        redirect_uri = "/search?keywords=#{keywords}"
      end
      redirect_to URI.escape(redirect_uri)
    end

    def result
      @searcher = Spree::Config.searcher_class.new(params.merge(currency: current_currency))
      @searcher.current_user = try_spree_current_user
      @products = make_random(@searcher.retrieve_products)
      @page = @searcher.properties[:page]
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

    # sort random not alpha betically
    
    def make_random(obj)
      q_length_ary = (0..obj.length-1).to_a
      a_length_ary = []
      if (obj.length-1)/2.to_i>0
        (obj.length-1)/2.to_i.times do 
          i = q_length_ary.sample
          q_length_ary.delete(i)
          a_length_ary << i
          j = q_length_ary.sample
          q_length_ary.delete(j)
          a_length_ary << j        
          obj[i], obj[j] = obj[j], obj[i]
        end
      end  
      return obj
    end  


  end
end
