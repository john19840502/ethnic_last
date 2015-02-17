require 'spec_helper'
# require 'spree_auth_devise'

describe 'Spree::UserMailer' do
  let!(:store) { create(:store) }
  let(:user) { FactoryGirl.create(:user) }

  context "reset password instructions email" do
    let(:email) { Spree::UserMailer.reset_password_instructions(user, user.reset_password_token) }

    specify { email.content_type.should match("text/html") }
  end
end
