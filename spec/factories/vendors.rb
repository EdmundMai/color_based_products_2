# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vendor do
    sequence(:name) { |n| "my-vendor#{n}" }
  end
end
