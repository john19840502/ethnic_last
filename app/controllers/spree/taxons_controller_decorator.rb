Spree::TaxonsController.class_eval do

    def show
      @taxon = Spree::Taxon.find_by_permalink!(params[:id])
      return unless @taxon

      @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
      @searcher.current_user = try_spree_current_user
      @products = @searcher.retrieve_products
      
      @brands = @taxon.fetch_uniq_product_brands
      
      if params[:price_filter_req].present? or params[:page].present?
		render :partial => 'spree/shared/products_list', :locals => { :products => @products, :taxon => @taxon }
	  else
        respond_with(@taxon)
      end
    end
    
end
