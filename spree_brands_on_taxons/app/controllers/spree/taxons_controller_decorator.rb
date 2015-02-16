Spree::TaxonsController.class_eval do

  def show
    @taxon = Spree::Taxon.friendly.find(params[:id])
    return unless @taxon

    @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true, current_user: current_spree_user))
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)
    #@products = @products.none if @taxon.try(:invisible?, current_spree_user)
    Rails.logger.error @products.count
  end

  #alias_method_chain :show, :check_taxons_visibility

end
