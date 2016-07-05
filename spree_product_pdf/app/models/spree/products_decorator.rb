Spree::Product.class_eval do
  has_attached_file :pdf_file
  attr_accessor :pdf_file_delete

  # validates_attachment_presence :pdf_file
  validates_attachment_content_type :pdf_file, :content_type => ['application/pdf']

  # include Spree::Core::S3Support
  # supports_s3 :pdf_file
  # Spree::Product.attachment_definitions[:pdf_file][:path] = '/spree/product_pdf_files/:id/:style/:basename.:extension' if Spree::Config[:use_s3]
  # Spree::Product.attachment_definitions[:pdf_file][:url] = ':s3_eu_url' if Spree::Config[:use_s3]

  before_save do
    self.send(:pdf_file).clear if self.pdf_file_delete == '1'
  end

end