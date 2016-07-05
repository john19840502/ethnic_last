$(function() {
	var currency_type;
	var currency = $("a[title='Currency selection'] small").text();
	if(currency == "USD")
		{currency_type = '$';}
	else
		{currency_type = '€';}
    var values = [25,2000];
    var href = window.location.href
    var matches = href.match( /^.*?price_range=(\d+)\+\-\+(\d+).*?$/);
    if(matches) {
        values = [parseInt(matches[1]), parseInt(matches[2])];
    }
        $( "#slider-range" ).slider({
		range: true,
		min: 25,
		max: 2000,
		values: values,
		slide: function( event, ui ) {
			$( "#amount" ).val(currency_type + ui.values[ 0 ] + " - " + currency_type + ui.values[ 1 ] );
		},
    change: function() {
      var full_url = set_current('page', 1);
  		var price_range = $('#amount').val();
  		var currency_type;
  		var currency = $("a[title='Currency selection'] small").text();
  		$('#amount').attr('class','true');
  		if(currency == "USD")
  			{price_range = price_range.replace(/\$/g,'')}
  		else
  			{price_range = price_range.replace(/\€/g,'')}

  //		window.location.replace(full_url + "&price_range=" + price_range);
  		$.ajax({
  		  type: 'get',
  		  url: full_url,
  		  dataType: 'script',
  		  data: {price_range: price_range}
  		 });
    }
	});

    var min_val = currency_type + $("#slider-range" ).slider("values", 0 );
    var max_val = values[1] == 2000 ? 'Max' : currency_type + $("#slider-range" ).slider("values", 1 );
	$( "#amount" ).val(min_val + " - " + max_val);
});
