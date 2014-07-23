# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coin do
    name "MyString"
    tag "MyString"
    thread "MyString"
    current_price 1.5
    current_volume 1.5
  end
end
