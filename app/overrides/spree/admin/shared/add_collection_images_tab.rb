Deface::Override.new(
  :virtual_path       => "spree/layouts/admin",
  :name               => "add_collection_request_tab",
  :insert_bottom      => "[data-hook='admin_tabs']",
  :text               => "<%= tab :collection_images %>",
  :disabled			  => false)
