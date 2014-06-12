# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    order_id 1
    quantity 1
    variant_id 1
    unit_price ""
  end
end
