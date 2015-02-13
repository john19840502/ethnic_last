require 'spec_helper'

describe 'Admin::Sliders' do

  stub_authorization!

  it 'adds a Sliders tab to the admin menu' do
    visit spree.admin_path
    expect(page).to have_link('Slider')
  end

  it 'can add a new slider' do
    visit spree.admin_path
    click_link 'Slider'
    click_link 'Add Slider'
    fill_in 'Group key', with: 'homepage'
    fill_in 'Url', with: 'products/t/banners'
    absolute_path = Rails.root + '../../spec/fixtures/files/logo-pero-ict.png'
    puts absolute_path
    attach_file('slider_image', absolute_path)
    click_button 'Create'
    expect(page).to have_content('successfully created')
  end

  it 'can edit a slider' do
    slider = create(:slider)
    visit spree.admin_path
    click_link 'Slider'
    click_link 'Edit'
    fill_in 'Url', with: 'target URL'
    click_button 'Update'
    expect(page).to have_content 'successfully updated'
    expect(page).to have_content 'target URL'
  end

  it 'cannot add a slider without an image' do
    visit spree.admin_path
    click_link 'Slider'
    click_link 'Add Slider'
    fill_in 'Group key', with: 'homepage'
    fill_in 'Url', with: 'products/t/banners'
    click_button 'Create'
    expect(page).to have_content 'error'
  end

end