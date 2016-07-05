Spree::Address.class_eval do

  def self.build_default
  	
    #country = Spree::Country.find(session[:country_id]) rescue Spree::Country.default
    country = Spree::Country.find(1) rescue Spree::Country.default
    new({country: country}, without_protection: true)
  end

  def postal_code_validate
    return
  end
end
