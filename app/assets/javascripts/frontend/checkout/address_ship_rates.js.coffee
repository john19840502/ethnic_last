Spree.ready ($) ->
  Spree.Rates = {}

  Spree.onAddressShipRates = () ->
    if ($ '#checkout_form_address').is('*')

      getCountryId = (region) ->
        $('#' + region + 'country select').val()

      Spree.updateShipping = (region) ->
        countryId = getCountryId(region)
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
          ($ '#shipping_rates').html("No shipping rates for your location.")
        else
          cost = rates["rates"][0]["cost"]
          currency = Spree.currency_sign(rates["currency"])
          ($ '#shipping_rates').html("Shipping will cost you " + currency + cost + ".")

      Spree.currency_sign = (currency) ->
        switch currency
          when "EUR" then '€'
          when "USD" then '$'
          else currency

      ($ '#bcountry select').change ->
        order_use_billing = ($ 'input#order_use_billing')
        if order_use_billing.is(':checked')
          Spree.updateShipping 'b'

      ($ '#scountry select').change ->
        Spree.updateShipping 's'

      Spree.updateShipping 'b'

      order_use_billing = ($ 'input#order_use_billing')
      order_use_billing.change ->
        update_shipping_rates order_use_billing

      update_shipping_rates = (order_use_billing) ->
        if order_use_billing.is(':checked')
          Spree.updateShipping('b')
        else
          Spree.updateShipping('s')

  Spree.onAddressShipRates()
