class CoinParser
  attr_accessor :result

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    process
  end

  def process
    if api = request_with_api
      @trx = Bittrex.new(api.key, api.secret)
      # todo: fix exchanges
      coins = coins_to_array(@params[:orders_history][:coin_id])
      coins_to_result(coins)
    else
      coin = Coin.find(@params[:orders_history][:coin_id])
      @result = OrdersHistory.add_manual(@current_user.id, @params)
    end
  end

  def coins_to_result(coins)
    names = coins.collect { |e| e[:name] }.join(", ")

    if coins.select{ |e| e[:status] == :success }.any?
      @result = { status: :success, message: "Successfully added #{names}." }
    else
      @result = { status: :error, message: "There are no new records for #{names}." }
    end
  end

  def coins_to_array(list)
    coins = []
    list.select { |e| e != "" }.each do |coin_id|
      coins << add_coin(coin_id)
    end
    coins
  end

  def add_coin(coin_id)
    coin = Coin.find(coin_id)
    history = @trx.order_history(coin.tag, 500)
    result = OrdersHistory.add_from_api(coin, @params[:orders_history][:exchange_id], @current_user.id, history)
    {status: result[:status], name: coin.tag }
  end

  def request_with_api
    @current_user.api.find(@params[:orders_history][:api_id])  if @params[:orders_history][:api_id]
  end
end









