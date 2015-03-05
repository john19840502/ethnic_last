class BrandsMigration < ::Migration

  IMAGE_SOURCE = "http://s3-eu-west-1.amazonaws.com/ethnic-chic-production/spree/brands"


  def migrate
    connection = self.external_connection

    brands = connection.execute("select * from spree_brands;")

    taxonomy = Spree::Taxonomy.create(name: 'Brands')
    parent_id = taxonomy.root.id

    ActiveRecord::Base.no_touching do
      Spree::Product.skip_callback(:create)

      brands.each_with_index do |brand, index|
        taxon = taxonomy.taxons.create!(
            name: brand[1],
            description: brand[2],
            parent_id: parent_id,
            child_index: index,
            enabled: brand[10],
            visibility: brand[11]
        )
        begin
          taxon.update icon: icon_link(brand_id: brand[0], image_name: brand[5])
        rescue OpenURI::HTTPError
        end
        product_ids = connection.execute("select id from spree_products where brand_id=#{brand[0]};")
        product_ids.each do |product_id|
          pr = Spree::Product.unscoped.find(product_id).first
          pr.taxons << taxon
          pr.save!(:validate => false)
        end
      end
      Spree::Product.set_callback(:create)
    end
  end

  def icon_link(options)
    brand_id = options[:brand_id]
    image_name = options[:image_name]

    "#{IMAGE_SOURCE}/#{brand_id}/original/#{image_name}"
  end
end