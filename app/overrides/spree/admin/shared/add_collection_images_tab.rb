Deface::Override.new(
  virtual_path: 'spree/layouts/admin',
  name: 'add_collection_image_tab',
  insert_bottom: '#main-sidebar',
  partial: 'spree/admin/collection_images/collection_image_menu',
  disabled: false)
