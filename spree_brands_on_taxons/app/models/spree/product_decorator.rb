Spree::Product.class_eval do

  scope :available_to, ->(user) { user.nil? ? visible : visible_to_logged_users }

  scope :visible, -> { where.not( id: Spree::Product.with_taxons_visibilities([2 ,3]) ) }
  scope :visible_to_logged_users, -> { where.not( id: Spree::Product.with_taxons_visibilities([3]) ) }

  scope :with_taxons_visibilities, ->(visibilities) { includes(:taxons).where(:spree_taxons => {visibility: visibilities}).map(&:id) }

  TAXONOMY_BRAND = 'Brands'

  def brand
    @product_brand ||= taxons.joins(:taxonomy).where(['spree_taxonomies.name = ?', TAXONOMY_BRAND]).first
  end
end