module Spree
  class AboutUsController < BaseController
    def show
      @brands = Spree::Taxon.find_by_permalink('brands').children.active
    end
  end
end
