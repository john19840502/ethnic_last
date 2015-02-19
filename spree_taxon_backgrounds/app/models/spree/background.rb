class Spree::Background < ActiveRecord::Base

  has_attached_file :image, :styles => {:thumb => "100x100>" },
      url: '/spree/backgrounds/:id/:style/:basename.:extension',
      path: ':rails_root/public/spree/backgrounds/:id/:style/:basename.:extension'
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  belongs_to :taxon, :class_name => "Spree::Taxon", :foreign_key => "taxon_id"
end
