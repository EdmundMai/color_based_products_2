# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :size do
    sequence(:name) { |n| "my-size#{n}" }
    sequence(:sort_order) { |n| n }
  end
end
