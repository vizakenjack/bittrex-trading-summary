# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :api do
    user
    exchange
    key "cea6abb7b4604f4792a561fa9a270dfd"
    secret "daa2605b517240198d4ee3bcab333b12"
    name "bittrex"
  end
end
