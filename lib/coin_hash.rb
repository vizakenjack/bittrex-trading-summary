class CoinHash
  attr_reader :result

  def initialize(coin)
    @result = Hash.new(0.0)
    @result.merge!({ id: coin.id, last_trade: nil, counter: 0 })
  end

  def add_filler_to_hash(filler)
    @result[:last_trade] = filler.output[:executed_at]  if @result[:last_trade].nil? or @result[:last_trade] < filler.output[:executed_at]

    add_bought_line(filler.output)  if filler.buy?
    add_sold_line(filler.output)  if filler.sell?

    @result[:counter] += 1
  end

  def any?
    @result[:counter] > 0
  end

  private

  def add_bought_line(output)
    @result[:amount_bought] += output[:amount]
    @result[:btc_amount_bought] += output[:btc_amount]
  end

  def add_sold_line(output)
    @result[:amount_sold] += output[:amount]
    @result[:btc_amount_sold] += output[:btc_amount]
  end
end