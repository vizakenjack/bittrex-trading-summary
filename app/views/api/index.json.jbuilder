json.array!(@api) do |api|
  json.extract! api, :id, :user_id, :exchange_id, :key, :secret
  json.url api_url(api, format: :json)
end
