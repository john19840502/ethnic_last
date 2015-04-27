module Spree
  class ColorAnalyzer

    def dominant_colors(image_path)
      Miro.options[:resolution] = '250x250'
      Miro.options[:color_count] = 4
      Miro.options[:method] = 'pixel_group'
      color_analyzer = Miro::DominantColors.new(image_path)
      colors = color_analyzer.to_hex
      color_analyzer.by_percentage.each_with_index.inject([]) do |memo, (color_percent, index)|
        memo << colors[index] if color_percent > 0.4
        memo
      end
    end

    def palete_similarity(image_path)
      dominant_colors(image_path).inject([]) do |memo, dcolor|
        Spree::PaletaColor::COLORS.each do |color|
          color1 = Paleta::Color.new(:hex, color)
          color2 = Paleta::Color.new(:hex, dcolor)
          if color1.similarity(color2) > 0.6
            memo << color
          end
        end
        memo
      end.uniq()
    end
  end
end
