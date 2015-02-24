class CollectionImage < ActiveRecord::Base
  # attr_accessible :name, :medium, :attachment, :position, :slider1, :slider2, :small, :url, :new_tab

  validates :position, :attachment, presence: true

  has_attached_file :attachment,
                      styles: {icon: '64x64', small: '220x80>', medium: '220x320>', slider1: '440x640>', slider2: '440x320>' },
                      default_style: :medium

  # include Spree::Core::S3Support
  # supports_s3 :attachment

  # CollectionImage.attachment_definitions[:attachment][:path] = '/spree/collection_images/:id/:style/:basename.:extension' if Spree::Config[:use_s3]
  # CollectionImage.attachment_definitions[:attachment][:url] = ':s3_eu_url' if Spree::Config[:use_s3]
end
