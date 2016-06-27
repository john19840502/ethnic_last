FactoryGirl.define do
  factory :slider, :class => Spree::Slider do
    group_key { "homepage" }
    # do not use fixture_file_upload (http://pivotallabs.com/avoid-using-fixture-file-upload-with-factorygirl-and-paperclip/)
    image_file_name { 'test.png' }
    image_content_type { 'image/png' }
    image_file_size { 1024 }
  end
end