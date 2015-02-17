require 'spec_helper'

describe "Checkout Order With SendCloud", js: true do

  let!(:product) { create(:product, :name => 'iPad', weight: 10.0) }
  let!(:calculator) { create(:ups_express_saver, preferences: {
                                                                   min_weight_kg: 32,
                                                                   starting_price: 33,
                                                                   price_per_kg: 34,
                                                                   min_purchase_amount_for_free_shipping: 35
                                               }
  )}
  let!(:shipping_method) { create(:ups_shipping_method, calculator: calculator) }
  let!(:payment_method) { create(:check_payment_method)}


  def fill_in_billing
    within("#billing") do
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

  def prepare_order_for_delivery
    visit spree.root_path
    click_link 'iPad'
    click_button 'Add To Cart'
    click_button 'Checkout'
    within("#guest_checkout") do
      fill_in "Email", :with => "test@example.com"
      click_button 'Continue'
    end
    wait_for_ajax
    fill_in_billing
    click_button "Save and Continue"
  end


  context 'User goes to delivery step' do
    before do
      prepare_order_for_delivery
      wait_for_ajax
    end
    it 'and able to choose UPS' do
      expect(page).to have_content("UPS")
      click_button "Save and Continue"
      # Payment step doesn't require any action
      click_button "Save and Continue"
      expect(page).to have_content("Your order has been processed successfully")
      expect(Spree::Order.first.shipments.last.shipping_method.name).to eql 'UPS'
    end
  end
end
