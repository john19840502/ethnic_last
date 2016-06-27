$ ->
  if ($ 'form#update-cart').is('*')
    ($ 'form#update-cart .ss-delete').show().one 'click', (e)->
      e.stopPropagation()
      e.preventDefault()
      ($ this).parents('li').find('input.line_item_quantity').val 0
      ($ this).parents('form').first().submit()
      false

  ($ 'form#update-cart').submit ->
    ($ 'form#update-cart #update-button').attr('disabled', true)
  true
