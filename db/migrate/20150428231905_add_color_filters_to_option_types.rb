class AddColorFiltersToOptionTypes < ActiveRecord::Migration
  def change
    Spree::OptionType.where(presentation: 'Color option').find_each do |ot|
      ot.update_attribute(:as_color_filter, true)
    end
    Spree::OptionType.where(presentation: 'Color options').find_each do |ot|
      ot.update_attribute(:as_color_filter, true)
    end
  end
end
