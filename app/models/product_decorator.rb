Spree::Product.class_eval do
  after_touch :generate_meta_tags

  delegate_belongs_to :master, :price_without_tax
  
  def combined_properties
    props = []
    product_properties.each do |product_property|
      props << [product_property.property.presentation, product_property.value]
    end
    taxon_filter_properties.each do |taxon_filter|
      props << [taxon_filter[0],taxon_filter[1]]
    end
    measurements_properties.each do |measurement_property|
      props << measurement_property
    end
    props
  end

  def taxon_filter_properties
    taxon_filter_props = []
    grouped_by_taxonomy = taxons.group_by(&:taxonomy)
    grouped_by_taxonomy.keys.select{|m| m.is_a_filter}.each do |key|
      taxon_filter_props << [ key.name, grouped_by_taxonomy[key].collect(&:name).join(', ') ]
    end
    taxon_filter_props
  end

  def measurements_properties

    measurements_props = []
    measurements = variants.measurements

    widths = measurements.collect(&:width).uniq.compact
    measurements_props << ['Width (cm)', widths.join(', ')] unless widths.empty?

    heights = measurements.collect(&:height).uniq.compact
    measurements_props << ['Height (cm)', heights.join(', ')] unless heights.empty?

    weights = measurements.collect(&:weight).uniq.compact
    measurements_props << ['Weight (g)', weights.join(', ')] unless weights.empty?

    repeats = measurements.collect(&:repeat).uniq.compact
    measurements_props << ['Repeat (cm)', repeats.join(',')] unless repeats.empty?

    measurements_props
  end

  def generate_meta_tags
    products = Spree::Product.all
    products.each do |product|

      # Set meta keywords value
      meta_keywords = []
      meta_keywords << product.name
      meta_keywords << product.brand.try(:name)
      meta_keywords << product.taxons.map(&:name)
      meta_keywords = meta_keywords.flatten
      product.meta_keywords = meta_keywords.join(",")

      # Set meta description value
      meta_description = []
      meta_description << "#{product.brand.try(:name)} online shop #{product.name} #{product.tax_category.name}"
      taxons_name = product.taxons.map(&:name)
      taxons_name[taxons_name.index(taxons_name.last)] = "#{taxons_name.last} - worldwide shipping" if taxons_name.present?
      meta_description << taxons_name
      product.meta_description = meta_description.flatten.join(",")
      product.save!
    end
  end
end