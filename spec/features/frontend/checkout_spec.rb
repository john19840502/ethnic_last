require 'spec_helper'

def generate_for_option_values(products)
  option_values_hash = {}
  products.each do |product|
    product.option_types.each do |ot|
      option_values_hash[ot.id.to_s] = ot.option_value_ids
    end
    product.option_values_hash = option_values_hash
    product.send(:build_variants_from_option_values_hash)
    product.save
  end
end

def update_weight_for_all_variants_of(products, weight)
  products.each do |product|
    product.update! weight: weight
    product.variants.each do |variant|
      variant.update! weight: weight
    end
  end
end

def fill_in_billing
  within("#checkout_form_address") do
    fill_in "First Name", :with => "Test"
    fill_in "Last Name", :with => "User"
    fill_in "Street Address", :with => "1 User Lane"
    fill_in "City", :with => "Adamsville"
    select "United States of America", :from => "order_bill_address_attributes_country_id"
    select "Alabama", :from => "order_bill_address_attributes_state_id"
    fill_in "Zip", :with => "35005"
    fill_in "Phone", :with => "555-123-4567"
  end
end

def add_ruby_on_rails_bag_to_cart(options = {})
  visit spree.products_path

  expect(page).to have_css('li#dropdown small', text: options[:expected_cart_items].to_s) if options[:expected_cart_items]

  click_link 'Bags'
  click_link 'Ruby on Rails Bag'
  click_button 'Add To Cart'
end

def add_wallpapers1_to_cart
  visit spree.products_path
  click_link 'Wallpapers'
  click_link 'Wallpapers1'
  click_link 'Meter (1.09 yard)'
  click_button 'Add To Cart'
end

def go_to_delivery_step
  click_button 'checkout-link'
  within("#checkout_form_registration") do
    fill_in "Email", :with => "test@example.com"
    click_button 'Continue'
  end
  fill_in_billing
  click_link_or_button 'Save and Continue'
end

def pay_by(payment_type)
  click_link_or_button 'Confirm and start payment'
  click_link_or_button payment_type
  click_link_or_button 'Verder naar uw webshop'
end

describe "Checkout", js: true do

  stub_authorization!

  before(:each) do

    option_type = FactoryGirl.create(:option_type, :name => 'Meter / Sample cutting', presentation: 'Order per Meter (1.09 yard) or a Sample cutting')
    meter_value = FactoryGirl.create(:option_value, :name => 'Meter ', presentation: 'Meter (1.09 yard)', option_type: option_type)
    sample_value = FactoryGirl.create(:option_value, :name => 'Sample Cutting', presentation: 'Sample Cutting', option_type: option_type)

    design_taxonomy = FactoryGirl.create(:taxonomy, :name => 'Design', :is_a_filter => true)
    root = design_taxonomy.root
    plain_taxon = FactoryGirl.create(:taxon, :name => 'Plain', :parent_id => root.id, taxonomy: design_taxonomy)
    nature_taxon = FactoryGirl.create(:taxon, :name => 'Nature', :parent_id => root.id, taxonomy: design_taxonomy)
    classic_taxon = FactoryGirl.create(:taxon, :name => 'Classic', :parent_id => root.id, taxonomy: design_taxonomy)


    taxonomy = FactoryGirl.create(:taxonomy, :name => 'Categories')
    root = taxonomy.root
    wallpapers_taxon = FactoryGirl.create(:taxon, :name => 'Wallpapers', :parent_id => root.id, taxonomy: taxonomy, filters: [design_taxonomy])
    fabrics_taxon = FactoryGirl.create(:taxon, :name => 'Fabrics', :parent_id => root.id, taxonomy: taxonomy, filters: [design_taxonomy])
    bags_taxon = FactoryGirl.create(:taxon, :name => 'Bags', :parent_id => root.id, taxonomy: taxonomy, filters: [design_taxonomy])
    mugs_taxon = FactoryGirl.create(:taxon, :name => 'Mugs', :parent_id => root.id, taxonomy: taxonomy)

    taxonomy = FactoryGirl.create(:taxonomy, :name => 'Brands', :is_a_filter => true)
    root = taxonomy.root
    apache_taxon = FactoryGirl.create(:taxon, :name => 'Apache', :parent_id => root.id, taxonomy: taxonomy)
    rails_taxon = FactoryGirl.create(:taxon, :name => 'Ruby on Rails', :parent_id => root.id, taxonomy: taxonomy)
    ruby_taxon = FactoryGirl.create(:taxon, :name => 'RubyTest', :parent_id => root.id, taxonomy: taxonomy)

    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Mug', :price => '15.99', :taxons => [rails_taxon, mugs_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Tote', :price => '15.99', :taxons => [rails_taxon, bags_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Bag', :price => '22.99', :taxons => [rails_taxon, bags_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Stein', :price => '16.99', :taxons => [rails_taxon, mugs_taxon])

    #Price for 1 centimeter
    wallpapers1 = FactoryGirl.create(:custom_product, name: 'Wallpapers1', price: '159.0', taxons: [rails_taxon, wallpapers_taxon])
    wallpapers2 = FactoryGirl.create(:custom_product, name: 'Wallpapers2', price: '229.0', taxons: [rails_taxon, wallpapers_taxon])
    wallpapers3 = FactoryGirl.create(:custom_product, name: 'Wallpapers3', price: '169.0', taxons: [rails_taxon, wallpapers_taxon])

    FactoryGirl.create(:product_option_type, product: wallpapers1, option_type: option_type)
    FactoryGirl.create(:product_option_type, product: wallpapers1, option_type: option_type)
    FactoryGirl.create(:product_option_type, product: wallpapers1, option_type: option_type)

    generate_for_option_values([wallpapers1, wallpapers2, wallpapers3])
    update_weight_for_all_variants_of([wallpapers1, wallpapers2, wallpapers3], 200)

    global_zone = FactoryGirl.create(:global_zone)
    calculator_preferences = { min_weight_kg: 0.01, starting_price: 7, price_per_kg: 0.52, min_purchase_amount_for_free_shipping: 350 }
    calculator = Spree::Calculator::UpsExpressSaver.new preferences: calculator_preferences
    Spree::ShippingMethod.create! name: 'test shipping method', shipping_categories: [wallpapers1.shipping_category],
                                  calculator: calculator, display_on: 1, tax_category: wallpapers1.tax_category, zones: [global_zone]

    FactoryGirl.create(:mollie_payment_method, preferences: { api_key: ENV['MOLLIE_TEST_API_KEY'] })

    store = Spree::Store.new url: 'test_url'
    store.save validate: false
  end

  describe "with fractional meters orders" do

    context 'User goes to products index' do
      before do
        page.driver.block_unknown_urls
        page.driver.allow_url("www.mollie.com")

        visit spree.products_path
      end

      it 'can order product by meters' do
        add_wallpapers1_to_cart
        fill_in 'order_line_items_attributes_0_quantity', with: '1.3'
        click_button 'update-button'
        expect(page).to have_content(/(\$|€)206\.7/)
        go_to_delivery_step
        expect(page).to have_content(/test shipping method (€|\$)7\.52/)
        click_link_or_button 'Save and Continue'
        pay_by('Creditcard')
        expect(page).to have_css('dl.advanced dt', text: 'Quantity')
        expect(page).to have_css('dl.advanced dd', text: '1.3')
      end

      it 'can order product by meters and quantity' do
        Spree::Config.track_inventory_levels = false
        add_wallpapers1_to_cart
        fill_in 'order_line_items_attributes_0_quantity', with: '1.5'
        click_button 'update-button'
        add_ruby_on_rails_bag_to_cart(expected_cart_items: 1.5)

        expect(page).to have_content(/(€|\$)261\.49/)
        go_to_delivery_step
        expect(page).to have_content(/test shipping method (€|\$)7\.52/)
        click_link_or_button 'Save and Continue'
        pay_by('PayPal')
        expect(page).to have_css('dl.advanced dt', text: 'Quantity')
        expect(page).to have_css('dl.advanced dd', text: '1.5')
      end

      it 'cannot order less then 1 meter' do
        add_wallpapers1_to_cart
        fill_in 'order_line_items_attributes_0_quantity', with: '0.6'
        click_button 'update-button'
        expect( find_field('order_line_items_attributes_0_quantity').value ).to eq('1.0')
      end
    end
  end
end
