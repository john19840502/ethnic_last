Spree::BaseHelper.class_eval do

  def money_with_currency(amount)
    if session[:currency] && session[:currency] == 'USD'
      m = Spree::Money.new(amount).money
      amount = m.exchange_to(:USD)
      amount.format
    else
      Spree::Money.new(amount).to_html
    end
  end
end
