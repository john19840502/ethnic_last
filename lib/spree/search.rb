class Search < Spree::Core::Search::Base

  def retrieve_products
    if keywords
      @products = Spree::Product.algolia_search(keywords)
    else
      @products = Spree::Product.active
    end
    # curr_page = page || 1

    # unless Spree::Config.show_products_without_price
    #   @products = @products.where("spree_prices.amount IS NOT NULL").where("spree_prices.currency" => current_currency)
    # end
    # @products = @products.page(curr_page).per(per_page)
  end
end