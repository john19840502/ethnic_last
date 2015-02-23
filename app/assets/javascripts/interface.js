// On page load
$(function() {

    externalLinks();

    // Load map if present
    if (elementExists($('#map_canvas'))) {
        initialize_map();
    }

    // Bind an onclick to touch dropdown menu
    if (elementExists($('#dropdown'))) {
        $('#dropdown').bind('click touchend', {element: '#dropdown > ul'}, toggleElement);
    }

    if (elementExists($('#currency_dropdown'))) {
        $('#currency_dropdown').bind('click touchend', {element: '#currency_dropdown > ul'}, toggleElement);
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
        target = '#filter_' + $(this).data("target");
        $(target).toggle();
        event.preventDefault();
    });

});


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
        $('html').bind('click touchend', {element: event.data.element}, toggleElement);

        // Prevent the element from disapearing when clicked
        $(event.data.element).bind('click touchend', function(event) {
            event.stopPropagation();
        });

    } else {
        $(event.data.element).unbind('click touchend');
        $('html').unbind('click touchend');
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
