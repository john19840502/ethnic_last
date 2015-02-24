class InformationRequest < ActiveRecord::Base
  # attr_accessible :address, :company, :email, :name, :question, :product_url
  
  validates_presence_of :address, :company, :email, :name, :question, :product_url
end
