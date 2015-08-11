Spree::Address.class_eval do
  def self.default
    country = Spree::Country.find(session[:country_id]) rescue Spree::Country.first
    new({country: country}, without_protection: true)
  end

  def postal_code_validate
    return
  end
end
