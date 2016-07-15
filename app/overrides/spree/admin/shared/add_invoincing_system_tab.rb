Deface::Override.new(
  virtual_path: 'spree/layouts/admin',
  name: 'add_invoicing_system_tab',
  insert_bottom: '#main-sidebar',
  partial: 'spree/admin/invoicing_system/invoicing_system_menu',
  disabled: false)
