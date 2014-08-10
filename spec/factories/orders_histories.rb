# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :orders_history do
    user nil
    coin nil
    exchange
    trade nil
    round nil
    sequence(:uuid) { |e| "aaaa-bbbb-cccc-dddd-#{e}" } 
    order_type 1
    amount 1.5
    price 1.5
    round_number 1
    added_by 1

    factory :buy_order do
        order_type 1
        amount 20
        price 0.01
        btc_amount 0.2
    end

    factory :sell_order do
        order_type 0
        amount 30
        price 0.02
        btc_amount 0.6
    end
  end

  trait :manual do
    added_by 0
  end

  factory :sell_order_manual, parent: :sell_order, traits: [:manual]
  factory :buy_order_manual, parent: :buy_order, traits: [:manual]
end


# create_table "orders_histories", force: true do |t|
#   t.integer  "user_id",                    null: false
#   t.integer  "coin_id",                    null: false
#   t.integer  "exchange_id",                null: false
#   t.integer  "order_type",   default: 0,   null: false
#   t.float    "amount",       default: 0.0, null: false
#   t.float    "price",        default: 0.0, null: false
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "uuid"
#   t.float    "btc_amount",   default: 0.0, null: false
#   t.integer  "added_by",     default: 0,   null: false
#   t.integer  "trade_id"
#   t.datetime "deleted_at"
#   t.datetime "executed_at"
#   t.integer  "round_number", default: 1,   null: false
#   t.integer  "round_id"
# end