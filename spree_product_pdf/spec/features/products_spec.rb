require 'spec_helper'

describe 'Admin::Products' do

  stub_authorization!

  before(:each) do
    @product = FactoryGirl.create(:base_product)
    visit spree.admin_products_path
    visit spree.edit_admin_product_path(@product)
    expect(page).to have_content('Pdf File')
  end

  # it 'adds a upload control to the admin panel for Product' do
  #   expect(page).to have_text('Upload the pdf tech sheet')
  # end

  # it 'can upload pdf file' do
  #   absolute_path = Rails.root + '../../spec/fixtures/files/test_pdf.pdf'
  #   puts Spree::Product.attachment_definitions[:pdf_file][:path].inspect
  #   attach_file('product_pdf_file', absolute_path)
  #   click_button 'Update'
  #   expect(page).to have_content("successfully updated!")
  # end

  # it 'can delete pdf file before save product' do
  #   absolute_path = Rails.root + '../../spec/fixtures/files/test_pdf.pdf'
  #   attach_file('product_pdf_file', absolute_path)
  #   page.check('product_pdf_file_delete')
  #   click_button 'Update'
  #   expect(page).not_to have_link('test_pdf.pdf')
  # end
end