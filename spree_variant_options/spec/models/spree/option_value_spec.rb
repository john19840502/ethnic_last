require 'spec_helper'

describe Spree::OptionValue do
  before do
    @images = Dir[File.expand_path("../../../support/images/*", __FILE__)]
  end

  context "a new option value" do

    before do
      @option_value = Spree::OptionValue.new
    end

    it "not have an image" do
      expect(@option_value.has_image?).to eq nil
    end

  end

  context "an existing option value" do

    before do
      @option_value = create(:option_value)
    end

    it "not have an image" do
      expect(@option_value.has_image?).to eq nil
    end

    context "with an image" do

      before do
        @path = @images.shuffle.first
        file = File.open(@path)
        @option_value.update_attributes(:image => file)
        file.close
      end

      it "have an image" do
        expect(@option_value.has_image?).to eq true
      end

      it "have small large and original images" do
        dir = File.expand_path("../../../dummy/public/spree/option_values/#{@option_value.id}", __FILE__)
        %w(small large original).each do |size|
          expect(File.exists?(File.join(dir, size, File.basename(@path)))).to eq true
        end
      end

    end

  end

  context "#for_product" do
    before do
      @product = create(:product_with_variants)
    end

    it "return uniq option_values" do
      unused = create(:option_value, :option_type => @product.option_types.first, :presentation => "Unused")
      expect(Spree::OptionValue.for_product(@product).include?(unused)).to eq false
    end

    it "retain option values sort order" do
      @unordered, @prev_position = false, 0
      Spree::OptionValue.for_product(@product).all.each do |ov|
        @unordered = true if @prev_position > ov.position
        @prev_position = ov.position
      end

      expect(@unordered).to eq false
    end

    it "return empty array when no variants" do
      product = create(:product)
      expect(Spree::OptionValue.for_product(product)).to eq []
    end
  end


end
