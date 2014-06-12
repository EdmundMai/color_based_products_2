# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :products_color do
    color
    product_id 1
    mens false
    womens false
    
    factory :products_color_with_variants_and_images do
      after(:create) do |pc, evaluator|
        pc.variants << FactoryGirl.create(:variant)
        pc.product_images << FactoryGirl.create(:product_image)
      end
    end
  end
end
