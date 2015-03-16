$(function() {
  $('ul.pagination').hide();
  $('#products').infinitescroll({
    navSelector: "ul.pagination",
    nextSelector: "ul.pagination a[rel=next]",
    itemSelector: "li.product",
    loading: {
      msgText  : "Loading...",
      finishedMsg: ""
    }
  });
});
