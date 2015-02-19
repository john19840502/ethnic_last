require 'spec_helper'

describe Spree::Impression do

  stub_authorization!

  it "adds a Impressions tab to the admin menu" do
    visit spree.admin_path
    within(:css, '#main-sidebar') { page.find_link("Impressions")['/admin/impressions'] }
  end

  it "can add a new impression" do
    visit spree.admin_path
    click_link "Impressions"
    click_link "New Impression"
    fill_in "Title", :with => "Our project"
    fill_in "Sub title", :with => "a great way to use our products"
    fill_in "Description", :with => "A long description can be put here."
    click_button "Create"
    page.should have_content "successfully created"
    page.should have_content "Our project"
    page.should have_content "a great way to use our products"
  end

  it "can edit an impression" do
    create(:impressions)
    visit spree.admin_path
    click_link "Impressions"
    click_link "Edit"
    fill_in "Title", :with => "Our project"
    fill_in "Sub title", :with => "a great way to use our products"
    fill_in "Description", :with => "A long description can be put here."
    click_button "Update"
    page.should have_content "successfully updated"
    page.should have_content "Our project"
    page.should have_content "a great way to use our products"
  end

  it "can upload multiple images for an impression" do

    test_file_path = File.expand_path('../../fixtures/files/logo-pero-ict.png', File.dirname(__FILE__))
    another_test_file_path = File.expand_path('../../fixtures/files/logo-pero-ict.png', File.dirname(__FILE__))

    visit spree.admin_path
    click_link "Impressions"
    click_link "New Impression"
    fill_in "Title", :with => "Our project"
    fill_in "Sub title", :with => "a great way to use our products"
    fill_in "Description", :with => "A long description can be put here."
    attach_file 'impression_bulk_images', test_file_path
    click_button "Create"
    page.should have_content "successfully created"
    page.should have_image "logo-pero-ict.png"
    page.should have_content "Our project"
    page.should have_content "a great way to use our products"
  end

  it "can set brands for an impression", js: true do
    test_file_path = File.expand_path('../../fixtures/files/logo-pero-ict.png', File.dirname(__FILE__))
    taxonomy = create(:taxonomy, name: 'Brands')
    taxon_ruby = create(:taxon, taxonomy: taxonomy, name: 'Ruby', parent: Spree::Taxon.find_by_name!('Brands') )
    taxon_apache = create(:taxon, taxonomy: taxonomy, name: 'Apache', parent: Spree::Taxon.find_by_name!('Brands') )


    visit spree.admin_path
    click_link "Impressions"
    click_link "New Impression"
    fill_in "Title", :with => "Our project"
    fill_in "Sub title", :with => "a great way to use our products"
    fill_in "Description", :with => "A long description can be put here."
    attach_file 'impression_bulk_images', test_file_path

    page.find('ul.select2-choices').click
    expect(page).to have_content('Brands -> Ruby')
    find('li', text: 'Brands -> Ruby').click
    click_button "Create"
    page.should have_content "successfully created"
    page.should have_image "logo-pero-ict.png"
    page.should have_content "Our project"
    page.should have_content "a great way to use our products"

    click_link "Edit"
    expect( page.find('ul.select2-choices') ).to have_content "Brands -> Ruby"
    expect( page.find('ul.select2-choices') ).not_to have_content "Brands -> Apache"
  end

end