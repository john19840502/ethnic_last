class InformationRequest < ActiveRecord::Base
  # attr_accessible :address, :company, :email, :name, :question, :product_url
  
  validates :address, :company, :email, :name, :question, :product_url, presence: true
end
