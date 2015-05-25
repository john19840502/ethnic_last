class ShippingMethodZonesMigration < ::Migration

  def migrate
    connection = self.external_connection

    Spree::ShippingMethod.all.each do |sm|
      legacy_shipping_method_sql = "select zone_id, shipping_category_id from spree_shipping_methods where id = #{sm.id};"
      result = connection.execute(legacy_shipping_method_sql)
      legacy_shipping_method_zone_id = result.first[0]
      legacy_shipping_method_category_id = result.first[1]
      sm.zones << Spree::Zone.find(legacy_shipping_method_zone_id)
      sm.shipping_categories << Spree::ShippingCategory.find(legacy_shipping_method_category_id)
      sm.save!
    end
  end
end
