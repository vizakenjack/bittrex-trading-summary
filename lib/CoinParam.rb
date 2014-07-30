class CoinParam
  def initialize(coin)
    coin_hash = {0}
    coin_hash = {
                  id: coin.id, 
                  amount_bought: 0.0, 
                  btc_amount_bought: 0.0, 
                  amount_sold: 0.0,
                  btc_amount_sold: 0.0, 
                  last_trade: nil, 
                  counter: 0
                }
  end

  
end