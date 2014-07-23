class OrdersHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :coin
  belongs_to :exchange
  belongs_to :trade

  attr_accessor :api_id
  acts_as_paranoid

  # t.references :user, index: true, null: false
  # t.references :coin, index: true, null: false
  # t.references :exchange, index: true, null: false
  # t.integer :order_type, null: false, default: 0
  # t.float :amount, null: false, default: 0.0
  # t.float :price, null: false, default: 0.0
  # uuid
  # total amount
  enum order_type: ['Sell', 'Buy']
  enum added_by: ['Manual', 'API']

  validates :user_id, presence: true
  validates :coin_id, presence: true
  validates :exchange_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :order_type, presence: true
  validates :added_by, presence: true
  

  def self.add_from_api(coin, exchange_id, user_id, history)
    # OrdersHistory.delete_all
    # Trade.delete_all

    coins = {}
    OrdersHistory.transaction do
      history.each do |line|
        order_type = 'Sell'  if line['OrderType'] == 'LIMIT_SELL' or line['OrderType'] == "Sell"
        order_type = 'Buy'  if line['OrderType'] == 'LIMIT_BUY' or line['OrderType'] == "Buy"
        amount = line['Quantity'] - line['QuantityRemaining']
        next  if amount == 0
        btc_amount = (amount * line['PricePerUnit'])
        date = Time.parse(line['TimeStamp'])
        order = self.create_with(coin_id: coin.id, user_id: user_id, exchange_id: exchange_id, order_type: order_type, \
        created_at: date, updated_at: Time.now, amount: amount, price: line['PricePerUnit'], \
        btc_amount: btc_amount, added_by: 'API').find_or_initialize_by(uuid: line['OrderUuid'])

        if order.new_record?
          coins[coin.name] = {id: coin.id, amount_bought: 0.0, btc_amount_bought: 0.0, amount_sold: 0.0, \
          btc_amount_sold: 0.0, last_trade: date, counter: 0}  unless coins[coin.name]

          if order_type == 'Buy'
            coins[coin.name][:amount_bought] += amount
            coins[coin.name][:btc_amount_bought] += btc_amount
          elsif order_type == 'Sell'
            coins[coin.name][:amount_sold] += amount
            coins[coin.name][:btc_amount_sold] += btc_amount
          end
          coins[coin.name][:last_trade] = date  if coins[coin.name][:last_trade] < date
          coins[coin.name][:counter] += 1
          return { status: :error, message: order.errors.full_messages }  unless order.save
        end
      end

      if coins.any?
        Trade.transaction do
          trade = Trade.create_new(coins[coin.name], user_id)
          self.where(coin_id: coin.id, user_id: user_id, exchange_id: exchange_id).update_all(trade_id: trade.id)
        end
        result = { status: :success, message: coins[coin.name][:counter], coin_name: coin.name }
      else
        result = { status: :error, message: ["There are no new records for #{coin.name}"] }
      end
    end

  end

  def self.add_manual(user_id, orders_history_params)
    OrdersHistory.transaction do

      order = self.new(orders_history_params)
      order.user_id = user_id
      order.added_by = 'Manual'
      return { status: :error, message: order.errors.full_messages }  unless order.save

      coin = {id: orders_history_params[:coin_id], amount_bought: 0, btc_amount_bought: 0, amount_sold: 0.0, \
      btc_amount_sold: 0.0, last_trade: order.created_at, counter: 1}

      if order.order_type == 'Buy'
        coin[:amount_bought] = order.amount
        coin[:btc_amount_bought] = order.amount * order.price
      elsif order.order_type == 'Sell'
        coin[:amount_sold] = order.amount
        coin[:btc_amount_sold] = order.amount * order.price
      end

      Trade.transaction do
        @trade = Trade.create_new(coin, user_id)
        self.where(coin_id: orders_history_params[:coin_id], user_id: user_id, exchange_id: orders_history_params[:exchange_id]).update_all(trade_id: @trade.id)
      end
    end

    result = { status: :success, message: 1 }
  end

end
