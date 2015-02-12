require 'spec_helper'

describe "UPS Express Saver" do
  stub_authorization!

  context "Admin" do
    before(:each) do
      visit spree.admin_path
    end

    describe "can configure a shipping method: " do
      before(:each) do
        Spree::ShippingCategory.create!(name: 'My category')

        click_link 'Configuration'
        click_link 'Shipping Methods'
      end

      it "should be able to create a new shipping method and set api key for it" do
        click_link 'admin_new_shipping_method_link'
        expect(page).to have_content("New Shipping Method")
        fill_in "shipping_method_name", with: "UPS Express Saver"
        within(".categories"){ check('My category') }
        select "UPS Express Saver", from: "calc_type"
        click_button "Create"
        expect(page).to have_content("successfully created!")

        fill_in "shipping_method_calculator_attributes_preferred_min_weight_kg", with: "32"
        fill_in "shipping_method_calculator_attributes_preferred_starting_price", with: "33"
        fill_in "shipping_method_calculator_attributes_preferred_price_per_kg", with: "34"
        fill_in "shipping_method_calculator_attributes_preferred_min_purchase_amount_for_free_shipping", with: "35"
        click_button "Update"

        expect(page).to have_content("successfully updated!")
        expect(find_field("shipping_method_calculator_attributes_preferred_min_weight_kg").value).to eql "32.0"
        expect(find_field("shipping_method_calculator_attributes_preferred_starting_price").value).to eql "33.0"
        expect(find_field("shipping_method_calculator_attributes_preferred_price_per_kg").value).to eql "34.0"
        expect(find_field("shipping_method_calculator_attributes_preferred_min_purchase_amount_for_free_shipping").value).to eql "35.0"
      end
    end
  end
end