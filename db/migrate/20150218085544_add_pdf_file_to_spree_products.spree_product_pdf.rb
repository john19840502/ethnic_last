# This migration comes from spree_product_pdf (originally 20130415093758)
class AddPdfFileToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :pdf_file_file_name,    :string
    add_column :spree_products, :pdf_file_content_type, :string
    add_column :spree_products, :pdf_file_file_size ,   :integer
    add_column :spree_products, :pdf_file_updated_at,   :datetime
  end
end
