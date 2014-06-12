# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :color do
    sequence(:name) { |n| "my-color#{n}"; }
  end
end
