# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tax do
    state_id 1
    zip_code "MyString"
    rate "9.99"
  end
end
