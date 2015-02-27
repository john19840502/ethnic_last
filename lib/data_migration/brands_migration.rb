class BrandsMigration < ::Migration
  def migrate
    connection = self.external_connection

    brands = connection.execute("select * from spree_brands;")

    taxonomy = Spree::Taxonomy.create(name: 'Brands')
    parent_id = taxonomy.root.id

    brands.each_with_index do |brand, index|
      taxonomy.taxons.create!(
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
    end

  end
end