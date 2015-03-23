Spree::TaxonsController.class_eval do

  def show
    @taxon = Spree::Taxon.find_by_permalink!(params[:id])
    return unless @taxon

    @searcher = Spree::Config.searcher_class.new(params.merge(taxon: @taxon.id, currency: current_currency))
    @searcher.current_user = try_spree_current_user
    @products = @searcher.retrieve_products
    @page = params[:page] || 1

    @brands = @taxon.fetch_uniq_product_brands

    if request.xhr?
      render :partial => 'spree/shared/products_list', :locals => { :products => @products, :taxon => @taxon, page: @page }
    else
      respond_with(@taxon)
    end
  end
end
