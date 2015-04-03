module Spree
  class ColorAnalyzer
    def initialize(image_path)
      @image_path = image_path
    end

    def dominant_colors
      color_analyzer = Miro::DominantColors.new("#{Rails.root}/public/#{@image_path}")
      colors = color_analyzer.to_hex
      color_analyzer.by_percentage.each_with_index.inject([]) do |memo, (color_percent, index)|
        memo << colors[index] if color_percent > 0.4
        memo
      end
    end

    def palete_similarity
      dominant_colors.inject([]) do |memo, dcolor|
        Spree::PaletaColor::COLORS.each do |color|
          color1 = Paleta::Color.new(:hex, color)
          color2 = Paleta::Color.new(:hex, dcolor)
          if color1.similarity(color2) > 0.7
            memo << color
          end
        end
        memo
      end.uniq()
    end
  end
end