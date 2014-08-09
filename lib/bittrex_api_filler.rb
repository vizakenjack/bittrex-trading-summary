class BittrexApiFiller
  attr_reader :output

  def initialize(history_record)
    @history_record = history_record
    @amount = @history_record['Quantity'] - @history_record['QuantityRemaining']
    set_order_type
    calculate_hash
  end

  def calculate_hash
    if order_filled?
      @output = {
        uuid: @history_record['OrderUuid'],
        order_type: @order_type,
        amount: @amount,
        price: @history_record['PricePerUnit'],
        btc_amount: (@amount * @history_record['PricePerUnit']),
        added_by: 'API',
        executed_at: Time.parse(@history_record['TimeStamp'])
      }
    end
  end

  def buy?
    @order_type == "Buy"
  end

  def sell?
    @order_type == "Sell"
  end

  private

  def order_filled?
    @amount != 0
  end

  def set_order_type
    if ["LIMIT_SELL", "MARKET_SELL"].include? @history_record['OrderType']
      @order_type = "Sell"
    elsif ["LIMIT_BUY", "MARKET_BUY"].include? @history_record['OrderType']
      @order_type = "Buy"
    end
  end
end