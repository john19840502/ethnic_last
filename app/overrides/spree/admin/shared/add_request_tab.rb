Deface::Override.new(
  :virtual_path       => "spree/layouts/admin",
  :name               => "add_request_tab",
  :insert_bottom      => "[data-hook='admin_tabs']",
  :text               => "<%= tab :information_requests %>",
  :disabled			  => false)
