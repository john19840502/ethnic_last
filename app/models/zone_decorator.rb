Spree::Zone.class_eval do
  # attr_accessible :for_popup

  def contains_country?(country)
    return false unless country
    members.any? do |zone_member|
      case zone_member.zoneable_type
      when 'Spree::Country'
        zone_member.zoneable_id == country.id
      when 'Spree::State'
        false
      else
        false
      end
    end
  end
end
