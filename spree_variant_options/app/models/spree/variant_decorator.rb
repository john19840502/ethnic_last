Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper

  # attr_accessible :option_values

  def price_without_tax
    amount_ex_vat = (price / 1.21)
    BigDecimal.new(amount_ex_vat.to_s).round(2, BigDecimal::ROUND_HALF_UP)
  end

  def to_hash(currency)

    #binding.pry
    if(currency && currency == "USD")
      amount = Spree::Money.new(self.price).money
      amount_without_tax = Spree::Money.new(self.price_without_tax).money
      usd_price = amount.exchange_to(:USD)
      usd_price_without_tax = amount_without_tax.exchange_to(:USD)
      {
        :id    => self.id,
        :count => self.total_on_hand,
        :price => usd_price.format,
        :price_without_tax => usd_price_without_tax.format
      }
    else
      {
        :id    => self.id,
        :count => self.total_on_hand,
        :price => Spree::Money.new(self.price).to_s,
        :price_without_tax => Spree::Money.new(self.price_without_tax).to_s
      }
    end
  end

end
