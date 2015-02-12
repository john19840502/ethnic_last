Deface::Override.new(
    virtual_path: 'spree/layouts/admin',
    name: 'sliders_admin_sidebar_menu',
    insert_bottom: '#main-sidebar',
    partial: 'spree/admin/shared/sliders_sidebar_menu'
)
