class ManualFiller
  attr_reader :output

  def initialize(params)
    @params = params
    @order_type = params["order_type"]
    calculate_hash
  end

  def calculate_hash
    @output = {
      order_type: @params["order_type"],
      amount: @params["amount"].to_f,
      price: @params["price"].to_f,
      btc_amount: (@params["amount"].to_f * @params["price"].to_f),
      added_by: 'Manual',
      executed_at: Time.now
    }
  end

  def buy?
    @order_type == "Buy"
  end

  def sell?
    @order_type == "Sell"
  end
end