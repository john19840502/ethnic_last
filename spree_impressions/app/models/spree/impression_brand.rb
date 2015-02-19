class Spree::ImpressionBrand < ActiveRecord::Base
  belongs_to :brand, class_name: 'Spree::Taxon'
  belongs_to :impression
end
