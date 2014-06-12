# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :billing_address do
    first_name "Net"
    last_name "Theory"
    street_address "7 Dey St"
    street_address2 "Suite 300"
    zip_code "10007"
  end
end
