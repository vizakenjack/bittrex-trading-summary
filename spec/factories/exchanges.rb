# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exchange do
    name "Bittrex"
    short_name "BTX"
    url "bittrex.com"
  end
end
