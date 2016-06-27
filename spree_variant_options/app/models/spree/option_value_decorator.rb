Spree::OptionValue.class_eval do

  # attr_accessible :image

  # default_scope order("#{quoted_table_name}.position")

  has_attached_file :image,
    :styles        => { :small => '40x30#', :large => '140x110#' },
    :default_style => :small,
    :url           => "/spree/option_values/:id/:style/:basename.:extension",
    :path          => ":rails_root/public/spree/option_values/:id/:style/:basename.:extension"

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


  # include Spree::Core::S3Support
  # supports_s3 :image
  # Spree::OptionValue.attachment_definitions[:image][:path] = '/spree/option_values/:id/:style/:basename.:extension' if Spree::Config[:use_s3]
  # Spree::OptionValue.attachment_definitions[:image][:url] = ':s3_eu_url' if Spree::Config[:use_s3]

  def has_image?
    image_file_name && !image_file_name.empty?
  end

  scope :ordered, -> { order("#{quoted_table_name}.position") }

  scope :for_product, lambda { |product| select("DISTINCT #{table_name}.*").where("spree_option_values_variants.variant_id IN (?)", product.variant_ids).ordered.joins(:variants)
  }
end
