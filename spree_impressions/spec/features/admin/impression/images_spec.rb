require "spec_helper"

describe Spree::Impression::Images do
  stub_authorization!

  it "adds an image to the impression", :js => true  do
    create(:impressions)
    visit spree.admin_path
    click_link "Impressions"
    click_link "Edit"
    click_link "Images (0)"
    test_file_path = File.expand_path('../../../fixtures/files/logo-pero-ict.png', File.dirname(__FILE__))
    click_link "New Image"
    puts test_file_path
    attach_file 'image_attachment', test_file_path
    fill_in "image_alt", :with => "Our project"
    click_button "Create"
    page.should have_content "successfully created"
    page.should have_image "logo-pero-ict.png"
    page.should have_content "Our project"
  end

end