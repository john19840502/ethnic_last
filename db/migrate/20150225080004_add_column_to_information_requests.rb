class AddColumnToInformationRequests < ActiveRecord::Migration
  def change
    add_column :information_requests, :product_url, :string
  end
end
