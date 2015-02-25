class ChangeFieldTypeInInformationRequests < ActiveRecord::Migration
  def up
	change_column :information_requests, :address, :text
	change_column :information_requests, :question, :text
  end

  def down
	change_column :information_requests, :address, :string
	change_column :information_requests, :question, :string
  end
end
