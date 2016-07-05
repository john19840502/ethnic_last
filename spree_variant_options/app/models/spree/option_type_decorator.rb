Spree::OptionType.class_eval do
  # attr_accessible :option_value_images

  attr_accessor :option_value_images
  before_save :process_option_value_images

  def process_option_value_images
    if option_value_images
      option_value_images.each do |img|
        name = File.basename(img.original_filename, '.*')
        self.option_values.new(:name => name, :presentation => name, :image => img )
      end
    end
  end
end