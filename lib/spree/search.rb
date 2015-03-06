class Search < Spree::Core::Search::Base
  def get_base_scope
    base_scope = Spree::Product.active
    base_scope = base_scope.in_taxon(taxon) unless taxon.blank?
    unless keywords.blank?
      base_scope = base_scope.joins(variants: :option_values, taxons: :taxonomy).search_like_any(['spree_products.name', 'spree_products.description', 'spree_taxons.name', 'spree_option_values.name'], keywords.split)
    end
    base_scope = add_search_scopes(base_scope)

    base_scope = add_eagerload_scopes(base_scope)
    base_scope.select('DISTINCT spree_products.id, spree_products.*')
  end
end