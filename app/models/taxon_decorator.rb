Spree::Taxon.attachment_definitions[:icon][:styles] = { small: '100x100>' }

Spree::Taxon.class_eval do
  def fetch_uniq_product_brands
    Rails.cache.fetch("brands-for-taxon-#{id}") do
      root_id = Spree::Taxon.find_by_permalink('brands').try(:id)

      # sql query for Spree::Taxon.joins(products: taxons) with first join on parent_id
      Spree::Taxon.joins('INNER JOIN "spree_products_taxons"
                          ON "spree_products_taxons"."taxon_id" = "spree_taxons"."id" AND "spree_taxons"."parent_id" = ' + root_id.to_s +
                             'INNER JOIN "spree_products" ON "spree_products"."id" = "spree_products_taxons"."product_id" AND "spree_products"."deleted_at" IS NULL
                        INNER JOIN "spree_products_taxons" "classifications_spree_products_join" ON "classifications_spree_products_join"."product_id" = "spree_products"."id"
                        INNER JOIN "spree_taxons" "taxons_spree_products" ON "taxons_spree_products"."id" = "classifications_spree_products_join"."taxon_id"'
      ).where('taxons_spree_products.id = ?', id).uniq.sort_by(&:name)
    end
  end

  def to_filter_params(params = {})
    type = brand? ? 'brands' : 'filters'
    filter_params = params[type].try(:dup) || []
    if(filter_params.include?(name.strip))
      filter_params.delete(name.strip)
    else
      filter_params << (Spree::Taxon.find(taxon_filter).name.strip)
    end
    filter_params.map {|f| "#{type}[]=#{f}"}.join('&')
  end

  def self.active
    where(enabled: true)
  end

  def self.brands_root
    find_by_permalink('brands')
  end

  def self.brands
    brands_root.children.active.order(:name) 
  end

  def brand?
    parent.present? && parent.permalink == 'brands'
  end
end
