# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    
    factory :admin_role do
      name "admin"
    end
  end
end
