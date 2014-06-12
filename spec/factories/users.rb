# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@nettheory.com" }
    password "test123"
    password_confirmation "test123"
    
    factory :admin_user do
      # after(:create) do |user, evaluator|
      #   user.roles << FactoryGirl.create(:admin_role)
      # end
      roles { |u| [u.association(:admin_role)]}
    end
  end
end
