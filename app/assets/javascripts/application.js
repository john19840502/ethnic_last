// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require turbolinks


//= require frontend/all
//= require library
//= require interface
//= require jquery.lazyload.min
//= require jquery.cycle
//= require jquery.touchSwipe
//= require fancybox
//= require jquery.infinitescroll
//= require spree/frontend/all
// require spree/backend/all

$(document).ready(function() {
    $("a#country_currency_selector").click(function(event){
        event.preventDefault();
        $('#country_selector').show();
    });

    if( $('input#order_use_billing').length ){
        $('input#order_use_billing').prop('checked', true);
        $('#shipping .inner').hide();
        $('#shipping .inner input, #shipping .inner select').prop('disabled', true);
    }

    var offset = 220;
    var duration = 500;
    $(window).scroll(function() {
        if ($(this).scrollTop() > offset) {
            $('#scroller').fadeIn(duration);
        } else {
            $('#scroller').fadeOut(duration);
        }
    });

    $('#scroller').click(function(event) {
        event.preventDefault();
        $('html,body').animate({scrollTop: 0}, duration);
        return false;
    })

});

//= require_tree .
