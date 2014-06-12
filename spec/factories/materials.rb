# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :material do
    sequence(:name) { |n| "my-material#{n}"}
  end
end
