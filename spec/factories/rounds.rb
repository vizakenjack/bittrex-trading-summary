# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :round do
    user
    coin
    amount_bought 100
    price_bought 1
    amount_sold 90
    price_sold 1.8
    amount_left 10
    amount_value 0.2
    profit 0.8
    percent "9.99"
    average_price_bought 0.01
    average_price_sold 0.02
    round_number 1
    current_round_number nil
    rounds nil
  end
end
