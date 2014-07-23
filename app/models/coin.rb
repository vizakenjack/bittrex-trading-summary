class Coin < ActiveRecord::Base
  default_scope { order('name') }

  def self.autoupdate
    api = Api.system
    bittrex = Bittrex.new(api.key, api.secret)
    coins = bittrex.summaries
    coins.each do |coin|
      name = coin['MarketName'].split("-")[1]
      coin_in_base = Coin.create_with(name: name, tag: name).find_or_initialize_by(name: name)
      coin_in_base.current_price = coin['Last']
      coin_in_base.current_volume = (coin["BaseVolume"] || 0.0)
      coin_in_base.save!
    end
  end
end
