#require 'devise_helper'

Spree::FrontendHelper.class_eval do
  #include Devise::Controllers::Helpers

  def taxons_tree(root_taxon, current_taxon, max_level = 1)
    return '' if max_level < 1 || root_taxon.children.empty?
    content_tag :div, class: 'list-group' do
      root_taxon.children.active.map do |taxon|
        css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'list-group-item active' : 'list-group-item'
        link_to(taxon.name, seo_url(taxon), class: css_class) + taxons_tree(taxon, current_taxon, max_level - 1)
      end.join("\n").html_safe
    end
  end

end