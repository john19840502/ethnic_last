class SpreeZonesForPopupMigration < ::Migration

  def migrate
    connection = self.external_connection

    zone_ids = connection.execute("select id from spree_zones where for_popup = 1;")
    zone_ids.each do |zone_id|
      zone = Spree::Zone.find(zone_id.first)
      zone.update! for_popup: true
    end

  end
end