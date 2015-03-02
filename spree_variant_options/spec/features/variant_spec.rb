require 'spec_helper'

describe "viewing products", type: :feature, js: true do

  context 'with track inventory levels' do

    before do
      Spree::Config[:track_inventory_levels] = true
      @product = FactoryGirl.create(:product)
      @size = FactoryGirl.create(:option_type)
      @color = FactoryGirl.create(:option_type, :name => "Color")
      @s = FactoryGirl.create(:option_value, :presentation => "S", :option_type => @size)
      @m = FactoryGirl.create(:option_value, :presentation => "M", :option_type => @size)
      @red = FactoryGirl.create(:option_value, :name => "Red", :presentation => "Red", :option_type => @color)
      @green = FactoryGirl.create(:option_value, :name => "Green", :presentation => "Green", :option_type => @color)
      @variant1 = FactoryGirl.create(:variant, :product => @product, :option_values => [@s, @red])
      @variant2 = FactoryGirl.create(:variant, :product => @product, :option_values => [@s, @green])
      @variant3 = FactoryGirl.create(:variant, :product => @product, :option_values => [@m, @red])
      @variant4 = FactoryGirl.create(:variant, :product => @product, :option_values => [@m, @green])

      @variant4.stock_items.last.adjust_count_on_hand(1)

      SpreeVariantOptions::VariantConfig.default_instock = false
    end

    it 'disallow choose out of stock variants' do

      SpreeVariantOptions::VariantConfig.allow_select_outofstock = false

      visit spree.product_path(@product)

      # variant options are not selectable
      within("#product-variants") do
        size = find_link('S')
        size.click
        expect( size.has_css?('.selected') ).to eq false
        color = find_link('Green')
        color.click
        expect( color.has_css?('.selected') ).to eq false
      end

      # add to cart button is still disabled
      expect( find('button', text: "Add To Cart")["disabled"] ).to eq 'true'
    end

    it 'allow choose out of stock variants' do
      SpreeVariantOptions::VariantConfig.allow_select_outofstock = true

      visit spree.product_path(@product)

      # variant options are selectable
      within("#product-variants") do
        size = find_link('S')
        size.click
        expect( size["class"].include?("selected") ).to eq true
        color = find_link('Green')
        color.click
        expect( color["class"].include?("selected") ).to eq true
      end
      # add to cart button is still disabled
      expect( find('button', text: "Add To Cart")["disabled"] ).to eq 'true'
    end

    it "choose in stock variant" do
      visit spree.product_path(@product)
      within("#product-variants") do
        size = find_link('M')
        size.click
        expect( size["class"].include?("selected") ).to eq true
        color = find_link('Green')
        color.click
        expect( color["class"].include?("selected") ).to eq true
      end
      # add to cart button is enabled
      expect( find('button', text: "Add To Cart")["disabled"] ).to eq nil
    end
  end

  context 'without inventory tracking' do

    before do
      Spree::Config[:track_inventory_levels] = false
      @product = FactoryGirl.create(:product)
      @size = FactoryGirl.create(:option_type)
      @color = FactoryGirl.create(:option_type, :name => "Color")
      @s = FactoryGirl.create(:option_value, :presentation => "S", :option_type => @size)
      @red = FactoryGirl.create(:option_value, :name => "Red", :presentation => "Red", :option_type => @color)
      @green = FactoryGirl.create(:option_value, :name => "Green", :presentation => "Green", :option_type => @color)
      @variant1 = @product.variants.create(:option_values => [@s, @red], :price => 10, :cost_price => 5)
      @variant2 = @product.variants.create(:option_values => [@s, @green], :price => 10, :cost_price => 5)
    end

    it "choose variant with track_inventory_levels to false" do

      visit spree.product_path(@product)
      within("#product-variants") do
        # debugger
        size = find_link('S')
        size.click
        expect( size["class"].include?("selected") ).to eq true
        color = find_link('Red')
        color.click
        expect( color["class"].include?("selected") ).to eq true
      end
      # add to cart button is enabled
      expect( find_button("Add To Cart")["disabled"] ).to eq nil
    end
  end
  
end