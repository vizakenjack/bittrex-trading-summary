class Coin < ActiveRecord::Base
  default_scope { order('name') }

  def update_price
    api = Api.system
    # todo: fix exchanges
    bittrex = Bittrex.new(api.key, api.secret)
    ticker = bittrex.ticker(self.tag)
    self.update_attribute :current_price, (ticker['Bid'] + ticker['Ask']) / 2
  end

  def self.autoupdate
    api = Api.system
    # todo: fix exchanges
    bittrex = Bittrex.new(api.key, api.secret)
    coins = bittrex.summaries
    return false unless coins
    coins.each do |coin|
      name = coin['MarketName'].split("-")[1]
      coin_in_base = Coin.create_with(name: name, tag: name).find_or_initialize_by(name: name)
      coin_in_base.current_price = (coin['Bid'] + coin['Ask']) / 2
      coin_in_base.current_volume = (coin["BaseVolume"] || 0.0)
      coin_in_base.save!
    end
  end

  def self.find_or_create(options)
    if new_coin = self.create_with(name: options[:tag]).find_or_initialize_by(tag: options[:tag]) and new_coin.new_record?
      api = Api.system
      bittrex = Bittrex.new(api.key, api.secret)
      ticker = bittrex.ticker(coin.tag)
    else
      new_coin
    end
  end
end
