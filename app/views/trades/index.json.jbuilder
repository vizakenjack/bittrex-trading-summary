json.array!(@trades) do |trade|
  json.extract! trade, :id, :user_id, :coin_id, :exchange_id, :amount_bought, :price_bought, :amount_sold, :price_sold, :amount_left, :amount_value, :profit, :percent
  json.url trade_url(trade, format: :json)
end
