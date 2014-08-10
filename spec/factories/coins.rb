# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coin do
    name "AxroCoin"
    tag "AXR"
    thread "-"
    current_price 0.01
    current_volume 50
  end
end
