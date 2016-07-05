require 'spec_helper'

describe Spree::Product do

  before do
    @methods = %w(option_values grouped_option_values variant_options_hash)
  end

  context "any product" do

    before do
      @product = FactoryGirl.create(:product)
    end

    it "have proper methods" do
      @methods.each do |m|
        expect(@product.respond_to?(m)).to eq true
      end
    end

  end

  context "a product with variants" do

    before do
      @product = FactoryGirl.create(:product_with_variants)
    end

    it "have variants and option types and values" do
      expect( @product.option_types.count ).to eq 2
      expect( @product.option_values.count ).to eq 12
      expect( @product.variants.count ).to eq 32
    end

    it "have values grouped by type" do
      expected = { "size" => 4, "color" => 8 }
      expect( @product.grouped_option_values.count ).to eq 2
      @product.grouped_option_values.each do |type, values|
        expect( values.length ).to eq expected[type.name]
      end
    end

  end

end