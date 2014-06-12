# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name "Lorem"
    short_description "sh0rtDesC"
    long_description "L0ngD3sc"
    active true
    page_title "My Title"
    meta_description "My Meta Description"
    
    factory :complete_product do
      after(:create) do |product, evaluator|
        product.products_colors << FactoryGirl.create(:products_color_with_variants_and_images, product_id: product.id)
        product.products_colors << FactoryGirl.create(:products_color_with_variants_and_images, product_id: product.id)
      end
    end

  end
end
