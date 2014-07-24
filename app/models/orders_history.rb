class OrdersHistory < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user, counter_cache: true
  belongs_to :coin
  belongs_to :exchange
  belongs_to :trade

  before_destroy :return_amount

  attr_accessor :api_id

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

    coin_hash = {}
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

      if coin_hash.present?
        create_user_and_trade(coin_hash, user_id, exchange_id)
        result = { status: :success, message: coin_hash[:counter], coin_name: coin.name }
      else
        result = { status: :error, message: ["There are no new records for #{coin.name}"] }
      end
    end

  end

  def self.add_manual(user_id, orders_history_params)
    OrdersHistory.transaction do

      order = self.new(orders_history_params)
      order.btc_amount = order.amount * order.price
      order.user_id = user_id
      order.added_by = 'Manual'
      return { status: :error, message: order.errors.full_messages }  unless order.save

      coin_hash = {id: orders_history_params[:coin_id], amount_bought: 0, btc_amount_bought: 0, amount_sold: 0.0, \
      btc_amount_sold: 0.0, last_trade: order.created_at, counter: 1}

      if order.order_type == 'Buy'
        coin_hash[:amount_bought] = order.amount
        coin_hash[:btc_amount_bought] = order.amount * order.price
      elsif order.order_type == 'Sell'
        coin_hash[:amount_sold] = order.amount
        coin_hash[:btc_amount_sold] = order.amount * order.price
      end

      create_user_and_trade(coin_hash, user_id, orders_history_params[:exchange_id])

    end

    result = { status: :success, message: 1 }
  end

  def return_amount
    if order_type == 'Buy'
      trade.amount_bought -= amount
      trade.price_bought -= btc_amount
    elsif order_type == 'Sell'
      trade.amount_sold -= amount
      trade.price_sold -= btc_amount
    end
    trade.recount_values

    trade.save!
  end

  def self.create_user_and_trade(coin_hash, user_id, exchange_id)
    Trade.transaction do
      @trade = Trade.where(coin_id: coin_hash[:id], user_id: user_id).first_or_initialize
      @trade.add_values(coin_hash)
      self.where(coin_id: coin_hash[:id], user_id: user_id, exchange_id: exchange_id).update_all(trade_id: @trade.id)
      
      User.transaction do
        user = User.find user_id
        user.btc_invested += coin_hash[:btc_amount_bought]
        user.btc_received += coin_hash[:btc_amount_sold]
        user.trade_profit += @trade.sold_more? ? @trade.actual_sold : (@trade.profit)
        user.save!
      end
    end
  end

end
