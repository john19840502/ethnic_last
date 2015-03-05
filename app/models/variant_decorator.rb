Spree::Variant.class_eval do
  # attr_accessible :repeat

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

end
