class BrandsMigration < ::Migration
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
            icon_file_name: brand[5],
            icon_content_type: brand[6],
            icon_file_size: brand[7],
            icon_updated_at: brand[8],
            enabled: brand[10],
            visibility: brand[11]
        )
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
end