Spree::TaxonsController.class_eval do

  def show
    filters = ["/search", params[:id]]
    if params[:brands].present?
      params[:brands].each do |brand_name|
        filters << "brands/#{brand_name.downcase}"
      end
    end

    if params[:filters].present?
      params[:filters].each do |taxon_filter|
        taxon = Spree::Taxon.find_by_name(taxon_filter)
        if taxon
          filters << taxon.permalink
        end
      end
    end

    redirect_to filters.join("/"), status: 301
  end
end
