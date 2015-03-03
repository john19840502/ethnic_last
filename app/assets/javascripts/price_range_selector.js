$(function() {
	var currency_type;
	var currency = $("a[title='Currency selection'] small").text();
	if(currency == "USD")
		{currency_type = '$';}
	else
		{currency_type = '€';}
	$( "#slider-range" ).slider({
		range: true,
		min: 25,
		max: 2000,
		values: [25,2000 ],
		slide: function( event, ui ) {
			$( "#amount" ).val(currency_type + ui.values[ 0 ] + " - " + currency_type + ui.values[ 1 ] );
		}
	});
	$( "#amount" ).val(currency_type + $("#slider-range" ).slider("values", 0 ) +
	" - " + currency_type + $("#slider-range" ).slider("values", 1 ));
});
