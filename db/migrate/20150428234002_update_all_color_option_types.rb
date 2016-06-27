class UpdateAllColorOptionTypes < ActiveRecord::Migration
  def change
    Spree::OptionType.where('LOWER(presentation) LIKE ?', '_olor option_').update_all(as_color_filter: true)
  end
end
