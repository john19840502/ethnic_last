class BackgroundsMigration < ::Migration

  def migrate
    connection = self.external_connection

    background_id_brand_names = connection.execute("select spree_backgrounds.id, spree_brands.name \
                from spree_backgrounds inner join spree_brands on spree_backgrounds.brand_id=spree_brands.id;")

    background_id_brand_names.each do |id_name|
      background_id = id_name.first
      brand_name = id_name.second
      background = Spree::Background.find background_id
      taxon = Spree::Taxon.find_by_name brand_name
      background.update taxon_id: taxon.id
    end

  end


end