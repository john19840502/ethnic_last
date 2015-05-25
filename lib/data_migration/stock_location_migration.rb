class StockLocationMigration < ::Migration
  def migrate

    stock_location = Spree::StockLocation.create!(
      name: "Default",
      default: true,
      address1: "Sarphatistraat 370 - A16",
      city: "Amsterdam",
      country: Spree::Country.where(iso3: "NLD").first,
      zipcode: "1018 GW",
      active: true,
      backorderable_default: true,
      propagate_all_variants: false,
      admin_name: "default"
    )

    Spree::Shipment.update_all("stock_location_id=#{stock_location.id}")
  end
end
