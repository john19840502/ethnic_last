Spree::OptionType.class_eval do
  def dominant_colors
    return [] unless self.as_color_filter

    Miro.options[:resolution] = '250x250'
    Miro.options[:color_count] = 4
    Miro.options[:method] = 'pixel_group'

    colors = []

    self.option_values.each do |ov|
      url = ov.image(:original)
      colors = Miro::DominantColors.new(url)

      hex_colors = colors.to_hex
      percentages = colors.by_percentage
      dominant_colors = []
      hex_colors.each_with_index do |c,i|
        dominant_colors << c if percentages[i] > 0.30
      end
      colors << dominant_colors
    end
    colors.flatten.uniq
  end
end
