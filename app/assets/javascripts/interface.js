// On page load
$(document).ready(function() {

    externalLinks();

    // Load map if present
    if (elementExists($('#map_canvas'))) {
        initialize_map();
    }

    // Bind an onclick to touch dropdown menu
    if (elementExists($('#dropdown'))) {
        $('#dropdown').off('click touchend').on('click touchend', {element: '#dropdown > ul'}, toggleElement);
    }

    if (elementExists($('#currency_dropdown'))) {
        $('#currency_dropdown').off('click touchend').on('click touchend', {element: '#currency_dropdown > ul'}, toggleElement);
    }

    if (elementExists($('#colors'))) {
      $('#toggleColors').bind('click touchend', {element: '#colors'}, toggleColors);
    }

    $('img.lazy').lazyload({
        effect : 'fadeIn',
        skip_invisible : false
    });

    if (elementExists($('#brand-list'))) {
        brandToggle();
    }

    if (elementExists($('.categories'))) {
      //filterToggle();
    }

    if(elementExists($('#facebook-share'))) {
        $('#facebook-share').bind('click touchend', function(event) {
            var url = $(this).attr('href');
            socialPopup(url);
            event.preventDefault();
        });
    }

    if (elementExists($('#slider'))) {
        activateSlider();
    }

    $(".toggle_filter").bind('click touchend', function(event){
        target = '#'+$(this).data("target");
        $(target).toggle();
        event.preventDefault();
    });

});

function filterToggle(){
  var $more = $('.more');
  var $less = $('.less');
  var $listitems = $('.more').parent('.li');
  var count = $('.more').parent.data('display');

  // Show first 8 brands
  lessBrands();

  $more.bind('click touchend', function() {
      more();
  });

  $less.bind('click touchend', function() {
      less();
  });

  function more() {
      $more.hide();
      $less.show();
      $listitems.show();
  }

  function less() {
      $more.show();
      $less.hide();
      $listitems.each(function(index, item) {
          if(index >= count) {
              $(item).hide();
          } else {
              $(item).show();
          }
      });
  }
}

function brandToggle() {
    var $more = $('#brands-more');
    var $less = $('#brands-less');
    var $listitems = $('#brand-list li');
    var count = $('#brand-list').data('display');

    // Show first 8 brands
    lessBrands();

    $more.bind('click touchend', function() {
        moreBrands();
    });

    $less.bind('click touchend', function() {
        lessBrands();
    });

    function moreBrands() {
        $more.hide();
        $less.show();
        $listitems.show();
    }

    function lessBrands() {
        $more.show();
        $less.hide();
        $listitems.each(function(index, item) {
            if(index >= count) {
                $(item).hide();
            } else {
                $(item).show();
            }
        });
    }
}


function activateSlider() {
    // Activate the slider
    var $slider = $('#slider').cycle({
        speed: 1500,
        timeout: 5000,
        slideResize: 0,
        pauseOnPagerHover: 1,
        activePagerClass: 'selected',
        pager: '#pages',
        pagerAnchorBuilder: function(index, slide) {
            return '<li><a></a></li>';
        }
    });

    // Allow swipers to swipe
    $slider.swipe({
        allowPageScroll: "vertical",
        swipeLeft: function() {
            $slider.cycle('next');
        },
        swipeRight: function() {
            $slider.cycle('prev');
        },
        threshold: 0
    });
}

function activateSimilarsSlider(){
    products_count = $('#similar-products .similar').length;
    product_length = $('#similar-products').width() / 3;
    for(var i = 0; i < products_count; i++){
        $('.similar-' + i.toString()).css({left: product_length * i});
    };
    left_similar_bound = 1;
    right_similar_bound = 3;
    $('.previous-similar').click(function(e){
        if(right_similar_bound < products_count){
            right_similar_bound++;
            left_similar_bound++;
            for(var i = 0; i < products_count; i++){
                el = $('.similar-' + i.toString());
                var left = (i + 1 - left_similar_bound) * product_length;
                el.animate({left: left}, 500);
            }
        }
        e.preventDefault();
        return false;
    });
    $('.next-similar').click(function(e){
        if(left_similar_bound > 1){
            right_similar_bound--;
            left_similar_bound--;
            for(var i = 0; i < products_count; i++){
                el = $('.similar-' + i.toString());
                var left = (i + 1 - left_similar_bound) * product_length;
                el.animate({left: left}, 500);
            }
        }
        e.preventDefault();
        return false;
    });
}

// Social popup windows
function socialPopup(url) {
    if(url.match(/facebook/g)) {
        window.open(url, 'Facebook share', 'height=340,width=690,resizable=0,toolbar=0,menubar=0,status=0,location=0,scrollbars=0');
        return true;
    } else if (url.match(/twitter/g)) {
        window.open(url, 'Twitter share', 'height=257,width=690,resizable=1,toolbar=0,menubar=0,status=0,location=0');
        return true;
    } else if (url.match(/mailto/g)) {
        window.open(url);
        return true;
    }
    return false;
}


// Dropdown function for touch
function toggleElement(event) {

    // Toggle visibility of the dropdown element
    $(event.data.element).toggle();

    if($(event.data.element).is(":visible")) {

        // Bind click function to the rest of the document
        $('html').off('click touchend').on('click touchend', {element: event.data.element}, toggleElement);

        // Prevent the element from disapearing when clicked
        $(event.data.element).off('click touchend').on('click touchend', function(event) {
            event.stopPropagation();
        });

    } else {
        $(event.data.element).off('click touchend');
        $('html').off('click touchend');
    }

    event.stopPropagation();
    event.preventDefault();
}



// Toggle colors function
function toggleColors(event) {
    $(event.data.element).toggle();
    event.preventDefault();
}

// Open links in other tab
function externalLinks() {
    if (!document.getElementsByTagName) return;
    var anchors = document.getElementsByTagName("a");
    for (var i=0; i<anchors.length; i++) {
        var anchor = anchors[i];
        if (
            anchor.getAttribute("href") && (
            anchor.getAttribute("rel") == "external" ||
            anchor.getAttribute("rel") == "external nofollow" ||
            anchor.getAttribute("rel") == "nofollow external" )
            )
        anchor.target = "_blank";
    }
}


// Initializing Google Maps
function initialize_map() {
    var location = new google.maps.LatLng(52.362707, 4.915520)
    var myOptions = {
      center: location,
      zoom: 16,
      keyboardShortcuts: false,
      scrollwheel: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
    var marker = new google.maps.Marker({
        position: location,
        map: map,
        icon: 'assets/marker.png',
        title: 'Ethnic Chic'
    });
}

function elementExists($element) {
    if($element.length) return true;
    return false;
}

function add_popup_click(){

    $(".pop").click(function(e){
        e.preventDefault();
        $("div.popout").hide();

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

function set_current(param, value){
    var href = url_with_param(param, value);
    window.history.replaceState("", "", href);
    return href;
}

function url_with_param(param, value) {
    var href = window.location.href;
    var params = {};
    params[param] = value;
    if (href.search(param) == -1) {
        var connector = href.search('\\?') == -1 ? '?' : '&';
        href += connector + $.param(params);
    } else {
        var re = new RegExp("(&|\\?)(" + param + "=)([\\w,+,-]+)(&.*)?");
        href = href.replace(re, '$1' + $.param(params) + '$4');
    }
    return href;
}

function update_favorites(count, is_added){
    if(is_added){
        $("#favorites span.glyphicon").addClass('red');
    } else {
        $("#favorites span.glyphicon").removeClass('red');
    }
    $("#favorites small").html(count);
}

function bind_click_on_favorites(){
    $("a#print-favorites").click(function(event){
        event.preventDefault();
        $("#favorites-index .modal-content #favorites-list").printThis({
            debug: false,
            importCSS: false,
            importStyle: false,
            printContainer: true,
            pageTitle: "Favorites",
            removeInline: false,
            printDelay: 700,
            header: null,
            formValues: true, loadCSS: "css/print-favorites.css"
        });
    });
}