json.array!(@coins) do |coin|
  json.extract! coin, :id, :name, :tag, :thread, :current_price, :current_volume
  json.url coin_url(coin, format: :json)
end
