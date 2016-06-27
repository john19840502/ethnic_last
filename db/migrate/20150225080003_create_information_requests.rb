class CreateInformationRequests < ActiveRecord::Migration
  def change
    create_table :information_requests do |t|
      t.string :email
      t.string :name
      t.string :company
      t.string :address
      t.string :question

      t.timestamps
    end
  end
end
