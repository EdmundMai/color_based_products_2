# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shape do
    sequence(:name) { |n| "my-shape#{n}"}
  end
end
