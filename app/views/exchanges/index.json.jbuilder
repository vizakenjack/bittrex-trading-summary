json.array!(@exchanges) do |exchange|
  json.extract! exchange, :id, :name, :short_name, :url
  json.url exchange_url(exchange, format: :json)
end
