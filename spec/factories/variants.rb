# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variant do
    weight "9.99"
    measurements "MyString"
    sku "abc123"
    price 11.22
    in_stock true
    size
  end
end
