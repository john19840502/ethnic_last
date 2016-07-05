class Spree::Slider < ActiveRecord::Base
  has_attached_file :image, styles: {thumb: '100x100>'}

  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => ['image/png', 'image/jpg']
  scope :by_group_key, -> (key) {where(group_key: key)}
  default_scope -> {order('position ASC')}
end
