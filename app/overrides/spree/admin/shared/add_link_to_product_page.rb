Deface::Override.new(
  :virtual_path       => "spree/admin/shared/_product_tabs",
  :name               => "add_link_to_product_page",
  :replace            => "h3",
  :text               => "<h3><%=link_to @product.name, @product %><span class='sku'><%= @product.sku %></span></h3>")
