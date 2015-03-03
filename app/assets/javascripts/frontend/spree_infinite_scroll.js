$(function() {
  $('nav.pagination').hide();
  $('#products').infinitescroll({
    navSelector: "nav.pagination",
    nextSelector: "nav.pagination a[rel=next]",
    itemSelector: "li.product",
    loading: {
      msgText  : "Loading...",
      finishedMsg: ""
    }
  });
});
