require 'spree/color_analyzer'
Spree::Variant.class_eval do
  has_attached_file :dominant_image,
                    styles: {image: '100x100'},
                    default_style: :image

  validates_attachment_presence :dominant_image
  validates_attachment_content_type :dominant_image, content_type: ['image/png', 'image/jpg']

  def total_on_hand
    #(1.0/0) #Infity
    1000000
  end

  def total_on_hand=(val)
    #ignore
  end

  def self.measurements
    select([:width, :height, :depth, :weight, 'spree_variants.repeat'])
  end

  def price_without_tax
    amount_ex_vat = (price / 1.21)
    BigDecimal.new(amount_ex_vat.to_s).round(2, BigDecimal::ROUND_HALF_UP)
  end

  def sorted_option_values
    values = self.option_values.sort do |a, b|
      a.option_type.position <=> b.option_type.position
    end
  end

  def weight
    self[:weight].to_f
  end

  def quantity_in_centimeters?
    self.option_values.map{|v| v.name.strip}.include?('Meter')
  end

end
