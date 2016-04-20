namespace :ethnicchic do
  task :generate_meta_tags, [:page, :per_page, :update_product] => :environment  do |t, args|
    products_without_taxons, products_without_brands = [], []

    page_no = (args[:page] || 1).to_i
    page_size = (args[:per_page] || 10).to_i
    update_product = (args[:update_product] || 0).to_i

    puts "Generating meta tags for products => page: #{page_no}, page size: #{page_size}"
    print_separator

    Spree::Product.order(:id).page(page_no).per(page_size).each_with_index do |product, index|
      products_without_taxons << product if product.taxons.empty?
      products_without_brands << product if product.brand.nil?

      meta_keywords = product.generate_meta_keywords
      meta_description = product.generate_meta_description

      puts "Product [id: #{product.id}]"
      puts "[Keywords]    : #{meta_keywords}"
      puts "[Description] : #{meta_description}"

      if update_product == 1
        product.save_meta_tags
        puts "Product updated with generated meta tags !"
      end

      print_separator
    end

    print_products_without_taxons(products_without_taxons)
    print_products_without_brands(products_without_brands)
  end

  task :generate_url, [:page, :per_page, :update_product] => :environment  do |t, args|
    page_no = (args[:page] || 1).to_i
    page_size = (args[:per_page] || 10).to_i
    update_product = (args[:update_product] || 0).to_i

    puts "Generating url for products page => #{page_no}, page size: #{page_size}"
    print_separator

    Spree::Product.order(:id).page(page_no).per(page_size).each_with_index do |product, index|
      puts "Product [id: #{product.id}]"

      url = product.generate_url
      puts "[URL] : [OLD: '#{product.slug}'] => [NEW: '#{url}']"

      if update_product == 1
        product.update(slug: url)
        puts "Product updated with generated url !"
      end

      print_separator
    end
  end

  private
    def print_separator
      (0..79).each { print "-" }
      print "\n"
    end

    def print_products_without_taxons(products_without_taxons)
      return if products_without_taxons.empty?
      puts "Products without taxons"
      print_separator
      products_without_taxons.each do |product|
        puts "#{product.id} : #{product.name}"
      end
    end

    def print_products_without_brands(products_without_brands)
      return if products_without_brands.empty?
      puts "Products without brands"
      print_separator
      products_without_brands.each do |product|
        puts "#{product.id} : #{product.name}"
      end
    end
end
