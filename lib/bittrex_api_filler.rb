class BittrexApiFiller
  attr_accessor :result

  def initialize(history_record)
    @history_record = history_record
  end

  def parse
    if check_amount
      
    end





    btc_amount = (amount * history_record['PricePerUnit'])
    date = Time.parse(history_record['TimeStamp'])
    order = self.create_with(coin_id: coin.id, user_id: user_id, exchange_id: exchange_id, order_type: order_type, \
    created_at: date, updated_at: Time.now, amount: amount, price: history_record['PricePerUnit'], \
    btc_amount: btc_amount, added_by: 'API').find_or_initialize_by(uuid: history_record['OrderUuid'])

    if order.new_record?
      coin_hash = {id: coin.id, amount_bought: 0.0, btc_amount_bought: 0.0, amount_sold: 0.0, \
      btc_amount_sold: 0.0, last_trade: date, counter: 0}  if coin_hash.empty?

      if order_type == 'Buy'
        coin_hash[:amount_bought] += amount
        coin_hash[:btc_amount_bought] += btc_amount
      elsif order_type == 'Sell'
        coin_hash[:amount_sold] += amount
        coin_hash[:btc_amount_sold] += btc_amount
      end
      coin_hash[:last_trade] = date  if coin_hash[:last_trade] < date
      coin_hash[:counter] += 1
      return { status: :error, message: order.errors.full_messages }  unless order.save
    end
  end

  private

  def check_amount
    @amount = history_record['Quantity'] - history_record['QuantityRemaining']
    @result = nil  if @amount == 0
  end

  def sell?
    @order_type ||= 'Sell'  if history_record['OrderType'] == 'LIMIT_SELL'
  end

  def buy?
    @order_type ||= 'Buy'  if history_record['OrderType'] == 'LIMIT_BUY'
  end
end