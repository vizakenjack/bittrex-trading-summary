# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trade do
    user nil
    coin nil
    exchange nil
    amount_bought 1.5
    price_bought 1.5
    amount_sold 1.5
    price_sold 1.5
    amount_left 1.5
    amount_value 1.5
    profit 1.5
    percent "9.99"
  end
end
