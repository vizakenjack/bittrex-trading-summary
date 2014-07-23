json.array!(@orders_histories) do |orders_history|
  json.extract! orders_history, :id, :user_id, :coin_id, :exchange_id, :order_type, :amount, :price
  json.url orders_history_url(orders_history, format: :json)
end
