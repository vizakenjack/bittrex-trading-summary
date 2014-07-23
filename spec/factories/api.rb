# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :api do
    user nil
    exchange nil
    key "MyString"
    secret "MyString"
  end
end
