$(function() {

  // workaround for backbutton
  window.scrollTo(0,0);

  $('ul.pagination').hide();
  $('#products').infinitescroll({
    navSelector: "ul.pagination",
    nextSelector: "ul.pagination a[rel=next]",
    itemSelector: "li.product",
    loading: {
      msgText  : "Loading...",
      finishedMsg: ""
    },
    debug: true,
    pathParse: function(path, state){
        console.log('Custom path.')
        if (path.match(/^(.*?page=)[0-9]+(\/.*|$)/)) {
            path = path.match(/^(.*?page=)([0-9]+)(\/.*|$)/).slice(1);
            var page_str = path.splice(1, 1);
            state.currPage = parseInt(page_str - 1);
            return path;
        } else {
            console.log('Path error.')
        }
    }
  }, function( data, opts ){
      $('#products').append(data);
      var page = opts.state.currPage - 1;
      set_current_page(page);
  });
});
