# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username "Vizakenjack"
    email "asd@asd.ru"
    password "123123"
    password_confirmation "123123"
    confirmed_at Time.now
  end

  factory :test, class: "User", parent: :user do
    username "Test"
    email "test@test.ru"
    password "456456"
    password_confirmation "456456"
    confirmed_at Time.now
  end
end
