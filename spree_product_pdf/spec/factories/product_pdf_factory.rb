FactoryGirl.define do
  factory :product_pdf, class: Spree::Product do

    # do not use fixture_file_upload (http://pivotallabs.com/avoid-using-fixture-file-upload-with-factorygirl-and-paperclip/)
    pdf_file_file_name { 'test_pdf.pdf' }
    pdf_file_content_type { 'application/pdf' }
    pdf_file_file_size { 1024 }
  end
end