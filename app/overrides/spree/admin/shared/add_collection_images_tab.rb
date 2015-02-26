Deface::Override.new(
  :virtual_path       => "spree/layouts/admin",
  :name               => "add_collection_request_tab",
  :insert_bottom      => "#main-sidebar",
  :text               => "<%= tab :collection_images %>",
  :disabled			  => false)
