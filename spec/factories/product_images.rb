include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :product_image do
    image { fixture_file_upload("#{Rails.root}/spec/support/sample_img.jpg", 'image/jpg') }
  end
end
