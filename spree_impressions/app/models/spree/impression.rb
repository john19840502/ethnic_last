class Spree::Impression < ActiveRecord::Base
  has_many :images, as: :viewable, dependent: :destroy
  attr_accessor :bulk_images
  before_save :process_bulk_images

  has_many :impression_brands
  has_many :brands, :through => :impression_brands

  def name
    title
  end

  def process_bulk_images
    if bulk_images
      bulk_images.each do |img|
        self.images.new(:attachment => img)
      end
    end
  end
end
