# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :orders_history do
    user nil
    coin nil
    exchange nil
    order_type 1
    amount 1.5
    price 1.5
  end
end
