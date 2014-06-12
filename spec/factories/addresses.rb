# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    first_name "MyString"
    last_name "MyString"
    street_address "MyString"
    street_address2 "MyString"
    zip_code "MyString"
    phone_number "MyString"
  end
end
