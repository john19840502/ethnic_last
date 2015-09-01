Spree.ready ($) ->
  Spree.Rates = {}

  Spree.updateShipping = () ->
    countryId = ($ '#shipping_rates').data('country')
    if countryId?
      unless Spree.Rates[countryId]?
        ($ '#shipping_rates').html('Calculating shipping cost...')
        $.get '/api/shipping_rates', {country_id: countryId}, (data) ->
          Spree.Rates[countryId] =
            rates: data.rates
            currency: data.currency
          Spree.show_rates(Spree.Rates[countryId])
      else
        Spree.show_rates(Spree.Rates[countryId])

  Spree.show_rates = (rates) ->
    if rates["rates"].length == 0
      ($ '#shipping_rates').html("Please proceed to checkout for the shipping rate on this order.")
    else
      cost = rates["rates"][0]["cost"]
      currency = Spree.currency_sign(rates["currency"])
      ($ '#shipping_rates').html("Shipping will cost you " + currency + cost + ".")

  Spree.currency_sign = (currency) ->
    switch currency
      when "EUR" then '€'
      when "USD" then '$'
      else currency

  Spree.updateShipping()
