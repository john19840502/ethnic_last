function hide_popouts(){
  $("div.popout").hide();
  $("div.locked-popout").hide();
}

function add_popup_click(){
  $(".pop").click(function(e){
    e.preventDefault();
    hide_popouts();

    $dropdown = $(this).parent().find("div.popout");
    $dropdown.show();


    $button = $(this);
    $container = $('.content');
    // Needs to be defined
    $arrow = $dropdown.find('.popout--arrow');

    var width = $dropdown.outerWidth();
    var buttonWidth = $button.width();
    var containerWidth = $container.outerWidth();
    var arrowWidth = $arrow.outerWidth();

    var left = $button.offset().left - $container.offset().left;
    var rightSpace = containerWidth - (left + (buttonWidth / 2));
    var leftSpace = left + (buttonWidth / 2);

    if(rightSpace < width / 2) {

      // Not enough space on the right side
      // Position the dropdown
      var dropdownLeft = - width + (buttonWidth / 2) + rightSpace - 5;
      // Position the arrow
      //var arrowLeft = - dropdownLeft + (buttonWidth / 2) - (arrowWidth / 2);

    } else if(leftSpace < width / 2) {

      // Not enough space on the left side
      var dropdownLeft = 0;

    } else {

      // Enough space on both sides
      var dropdownLeft = - (width / 2) + (buttonWidth / 2);
      var arrowLeft = - dropdownLeft + (buttonWidth / 2) - (arrowWidth / 2);
    }

    var arrowLeft = - dropdownLeft + (buttonWidth / 2) - (arrowWidth / 2);

    $arrow.css({
      left: arrowLeft
    });

    $dropdown.css({
      'left': dropdownLeft
    })

  });
}

function add_locked_popup_click(){
  $('#product-variants .locked').unbind('click');
  $('#product-variants .locked').click(function(e){
    e.preventDefault();
    hide_popouts();
    $(this).parent().find('.locked-popout').show();
  });
}



$.extend({
  keys: function(obj){
    var a = [];
    $.each(obj, function(k){ a.push(k) });
    return a;
  }
});

if (!Array.indexOf) Array.prototype.indexOf = function(obj) {
  for(var i = 0; i < this.length; i++){
    if(this[i] == obj) {
      return i;
    }
  }
  return -1;
}

if (!Array.find_matches) Array.find_matches = function(a) {
  var i, m = [];
  a = a.sort();
  i = a.length
  while(i--) {
    if (a[i - 1] == a[i]) {
      m.push(a[i]);
    }
  }
  if (m.length == 0) {
    return false;
  }
  return m;
}

function VariantOptions(params) {

  var options = params['options'];
  var allow_backorders = !params['track_inventory_levels'] ||  params['allow_backorders'];
  var allow_select_outofstock = params['allow_select_outofstock'];
  var default_instock = params['default_instock'];

  var variant, divs, parent, index = 0;
  var selection = [];
  var buttons;


  function init() {
    divs = $('#product-variants .variant-options');
    disable(divs.find('a.option-value').addClass('locked'));
    update();
    enable(parent.find('a.option-value'));
    toggle();
    $('.clear-option a.clear-button').hide().click(handle_clear);

    if (default_instock) {
      divs.each(function(){
        $(this).find("ul.variations li a.in-stock:first").click();
      });
    }

    $(".popout a").click(function(evt){
      evt.preventDefault();
      li = $(this).parent().parent();
      $(this).parent().hide();
      handle_popup_click(li.find("a.option-value"));
    });
    advance();
  }

  function handle_popup_click(a){
    variant = null;
    selection = [];
    if (!parent.has(a).length) {
      clear(divs.index(a.parents('.variant-options:first')));
    }
    disable(buttons);
    var a = enable(a.addClass('selected'));
    parent.find('a.clear-button').css('display', 'block');
    advance();
    if (find_variant()) {
      toggle();
    }
  }

  function get_index(parent) {
    return parseInt($(parent).attr('class').replace(/[^\d]/g, ''));
  }

  function update(i) {
    index = isNaN(i) ? index : i;
    parent = $(divs.get(index));
    buttons = parent.find('a.option-value');
    parent.find('a.clear-button').hide();
  }

  function disable(btns) {
    $("#product-variants li").removeClass("selected");
    return btns.removeClass('selected');
  }

  function enable(btns) {
    bt = btns.not('.unavailable').removeClass('locked').unbind('click')
    if (!allow_select_outofstock && !allow_backorders)
      bt = bt.filter('.in-stock')
    $("a.selected").parent().addClass("selected");
    return bt.click(handle_click).filter('.auto-click').removeClass('auto-click').click();
  }

  function advance() {
    index++
    update();
    inventory(buttons.removeClass('locked'));
    enable(buttons);
    add_popup_click();
    add_locked_popup_click();
  }

  function inventory(btns) {
    var keys, variants, count = 0, selected = {};
    var sels = $.map(divs.find('a.selected'), function(i) { return i.rel });
    $.each(sels, function(key, value) {
      key = value.split('-');
      var v = options[key[0]][key[1]];
      keys = $.keys(v);
      var m = Array.find_matches(selection.concat(keys));
      if (selection.length == 0) {
        selection = keys;
      } else if (m) {
        selection = m;
      }
    });
    btns.removeClass('in-stock out-of-stock unavailable').each(function(i, element) {
      variants = get_variant_objects(element.rel);
      keys = $.keys(variants);
      if (keys.length == 0) {
        disable($(element).addClass('unavailable locked').unbind('click'));
      } else if (keys.length == 1) {
        _var = variants[keys[0]];
        $(element).addClass((allow_backorders || _var.count) ? selection.length == 1 ? 'in-stock auto-click' : 'in-stock' : 'out-of-stock');
      } else if (allow_backorders) {
        $(element).addClass('in-stock');
      } else {
        $.each(variants, function(key, value) { count += value.count });
        $(element).addClass(count ? 'in-stock' : 'out-of-stock');
      }
    });
  }

  function get_variant_objects(rels) {
    var i, ids, obj, variants = {};
    if (typeof(rels) == 'string') { rels = [rels]; }
    var otid, ovid, opt, opv;
    i = rels.length;
    try {
      while (i--) {
        ids = rels[i].split('-');
        otid = ids[0];
        ovid = ids[1];
        opt = options[otid];
        if (opt) {
          opv = opt[ovid];
          ids = $.keys(opv);
          if (opv && ids.length) {
            var j = ids.length;
            while (j--) {
              obj = opv[ids[j]];
              if (obj && $.keys(obj).length && 0 <= selection.indexOf(obj.id.toString())) {
                variants[obj.id] = obj;
              }
            }
          }
        }
      }
    } catch(error) {
      //console.log(error);
    }
    return variants;
  }

  function to_f(string) {
    return parseFloat(string.replace(/[^\d\.]/g, ''));
  }

  function find_variant() {
    var selected = divs.find('a.selected');
    var variants = get_variant_objects(selected.get(0).rel);
    if (selected.length == divs.length) {
      return variant = variants[selection[0]];
    } else {
      var prices = [];
      if( $('input#show_price_ex_vat').val() == "1"){
        $.each(variants, function(key, value) { prices.push(value.price_without_tax) });
      }else{
        $.each(variants, function(key, value) { prices.push(value.price) });
      }

      prices = $.unique(prices).sort(function(a, b) {
        return to_f(a) < to_f(b) ? -1 : 1;
      });
      if (prices.length == 1) {
        $('#product-price .price').html('<span class="price assumed">' + prices[0] + '</span>');
        $('#product-price').addClass("has-update");
      } else {
        $('#product-price .price').html('<span class="price from">' + prices[0] + '</span> - <span class="price to">' + prices[prices.length - 1] + '</span>');
        $('#product-price').addClass("has-update");
      }
      return false;
    }
  }

  function toggle() {
    if (variant) {
      $('#variant_id, form[data-form-type="variant"] input[name$="[variant_id]"]').val(variant.id);
      if( $('input#show_price_ex_vat').val() == "1"){
        $('#product-price .price').removeClass('unselected').text(variant.price_without_tax);
        $('#product-price .price').removeClass('has-update')
      }else{
        $('#product-price .price').removeClass('unselected').text(variant.price);
        $('#product-price .price').removeClass('has-update')
      }
      if (variant.count > 0 || allow_backorders)
        if( $('#cart-form button[type=submit]').attr('disabled') == 'disabled') {
          $('#cart-form button[type=submit]').attr('disabled', false).fadeTo(100, 1);
          $('form[data-form-type="variant"] button[type=submit]').attr('disabled', false).fadeTo(100, 1);
        }
        $('#product-price .price').removeClass('has-update')
      try {
        show_variant_images(variant.id);
      } catch(error) {
        // depends on modified version of product.js
      }
    } else {
      $('#variant_id, form[data-form-type="variant"] input[name$="[variant_id]"]').val('');
      $('#cart-form button[type=submit], form[data-form-type="variant"] button[type=submit]').attr('disabled', true).fadeTo(0, 0.5);
      price = $('#product-price .price').addClass('unselected')
      // Replace product price by "(select)" only when there are at least 1 variant not out-of-stock
      variants = $("div.variant-options.index-0")
      if (variants.find("a.option-value.out-of-stock").length != variants.find("a.option-value").length)
        price.text('(select)');
    }
  }

  function clear(i) {
    variant = null;
    update(i);
    enable(buttons.removeClass('selected'));
    toggle();
    parent.nextAll().each(function(index, element) {
      disable($(element).find('a.option-value').show().removeClass('in-stock out-of-stock').addClass('locked').unbind('click'));
      $(element).find('a.clear-button').hide();
    });
    show_all_variant_images();
  }


  function handle_clear(evt) {
    evt.preventDefault();
    clear(get_index(this));
  }

  function handle_click(evt) {
    evt.preventDefault();
    variant = null;
    selection = [];
    var a = $(this);
    if (!parent.has(a).length) {
      clear(divs.index(a.parents('.variant-options:first')));
    }
    disable(buttons);
    var a = enable(a.addClass('selected'));
    parent.find('a.clear-button').css('display', 'block');
    advance();
    if (find_variant()) {
      toggle();
    }
  }

  $(document).ready(init);

};
