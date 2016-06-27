Deface::Override.new(
    virtual_path: 'spree/layouts/admin',
    name: 'add_collection_request_tab',
    insert_bottom: '#main-sidebar',
    partial: 'spree/admin/information_requests/information_request_menu',
    disabled: false)
