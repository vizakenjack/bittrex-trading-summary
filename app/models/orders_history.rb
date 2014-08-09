class OrdersHistory < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user, counter_cache: true
  belongs_to :coin
  belongs_to :exchange
  belongs_to :trade

  before_destroy :return_amount_and_save
  before_update :return_amount
  after_update :add_amount_and_save

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
    coin_hash = CoinHash.new(coin)
    params = { coin_id: coin.id, user_id: user_id, exchange_id: exchange_id }

    OrdersHistory.transaction do
      history.each do |history_record|

        filler = BittrexApiFiller.new(history_record)
        filler.output.present? ? params.merge!(filler.output) : next

        order = self.create_with(params).find_or_initialize_by(uuid: params[:uuid])
        coin_hash.add_filler_to_hash(filler)  if order.new_record? and filler.present?
        return { status: :error, message: order.errors.full_messages }  unless order.save
      end

      create_user_and_trade(coin_hash, coin.name, params)
    end
  end

   

  def self.add_manual(user_id, orders_history_params)
    coin = Coin.find orders_history_params[:coin_id]
    coin_hash = CoinHash.new(coin)
    params = { coin_id: coin.id, user_id: user_id, exchange_id: orders_history_params[:exchange_id] }

    OrdersHistory.transaction do
      filler = ManualFiller.new(orders_history_params)
      params.merge!(filler.output)

      order = self.new(params)
      coin_hash.add_filler_to_hash(filler)  if order.new_record? and filler.present?
      return { status: :error, message: order.errors.full_messages }  unless order.save
    end

    create_user_and_trade(coin_hash, coin.name, params)

    { status: :success, message: 1 }
  end

  def self.create_user_and_trade(coin_hash, coin_name, params)
    if coin_hash.any?
      Trade.transaction do
        @trade = Trade.where(coin_id: params[:coin_id], user_id: params[:user_id]).first_or_initialize
        @trade.add_values(coin_hash.result)
        self.where(coin_id: params[:coin_id], user_id: params[:user_id], exchange_id: params[:exchange_id]).update_all(trade_id: @trade.id)
        
        User.transaction do
          user = User.find params[:user_id]
          user.btc_invested += coin_hash.result[:btc_amount_bought]
          user.btc_received += coin_hash.result[:btc_amount_sold]
          user.trade_profit += @trade.sold_more? ? @trade.actual_sold : (@trade.profit)
          user.save!
        end
      end

      { status: :success, message: coin_hash.result[:counter], coin_name: coin_name }
    else
      { status: :error, message: ["There are no new records for #{coin_name}"] }
    end
  end

  def return_amount
    if order_type == 'Buy'
      trade.amount_bought -= amount_was
      trade.price_bought -= btc_amount_was
    elsif order_type == 'Sell'
      trade.amount_sold -= amount_was
      trade.price_sold -= btc_amount_was
    end
    # p "removed anount: #{amount_was} and btc: #{btc_amount_was}"
  end

  def add_amount
    self.update_column :btc_amount, (amount * price)
    if order_type == 'Buy'
      trade.amount_bought += amount
      trade.price_bought += btc_amount
    elsif order_type == 'Sell'
      trade.amount_sold += amount
      trade.price_sold += btc_amount
    end
    # p "added anount: #{amount} and btc: #{amount * price}"
  end

  def return_amount_and_save
    return_amount
    trade.recount_values
    trade.save!
  end

  def add_amount_and_save
    add_amount
    trade.recount_values
    trade.save!
  end


end
