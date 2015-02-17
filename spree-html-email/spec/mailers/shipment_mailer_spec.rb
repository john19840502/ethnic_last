require 'spec_helper'

describe 'Spree::ShipmentMailer' do
  before do
    @address = FactoryGirl.create(:address)
    @shipment = FactoryGirl.create(:shipment)
    @shipment.update(address_id: @address.id)
  end

  context "shipped email" do
    let(:email) { Spree::ShipmentMailer.shipped_email(@shipment) }

    specify { email.content_type.should match("text/html") }
  end
end
