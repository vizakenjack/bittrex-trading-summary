class OrdersHistory < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :coin
  belongs_to :exchange
  belongs_to :trade
  belongs_to :round

  before_destroy :decrease_values_of_round_and_trade
  # before_destroy :return_amount_and_save
  before_update :return_amount,  unless: "round_number_changed?"
  before_update :update_round_values,  unless: "round_number_changed?"
  after_update :add_amount_and_save,  unless: "round_number_changed?"
  after_update 'user.total_recount',  unless: "round_number_changed?"

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
  validates :round_number, presence: true, inclusion: { in: 1..999 }, allow_nil: false
  

  def self.add_from_api(coin, exchange_id, user_id, history)
    coin_hash = CoinHash.new(coin)
    params = { coin_id: coin.id, user_id: user_id, exchange_id: exchange_id }

    OrdersHistory.transaction do
      #todo : works only with bittrex
      return { status: :error, message: "Invalid market" }  if history == "INVALID_MARKET"
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

   

  def self.add_manual(user_id, oh_params)
    coin = Coin.find oh_params[:orders_history][:coin_id]
    coin_hash = CoinHash.new(coin)
    params = { coin_id: coin.id, user_id: user_id, exchange_id: oh_params[:orders_history][:exchange_id] }

    OrdersHistory.transaction do
      filler = ManualFiller.new(oh_params[:orders_history])
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
        # after_create :create_round
        @trade = Trade.where(coin_id: params[:coin_id], user_id: params[:user_id]).first_or_initialize
        is_new_record = @trade.new_record?
        @trade.add_values(coin_hash.result)
        
        @round = Round.where(coin_id: params[:coin_id], user_id: params[:user_id], round_number: @trade.current_round_number).first_or_initialize
        @round.add_values(coin_hash.result)  unless is_new_record
        @trade.add_rounds(@trade.current_round_number)  if @trade.current_round_number != 1
        
        self.where(
          coin_id: params[:coin_id], 
          user_id: params[:user_id], 
          exchange_id: params[:exchange_id]
        ).update_all(trade_id: @trade.id, round_id: @round.id, round_number: @trade.current_round_number)

        user = User.find params[:user_id]
        user.recount_profit(coin_hash, @trade)
      end

      { status: :success, message: coin_hash.result[:counter], coin_name: coin_name }
    else
      { status: :error, message: ["There are no new records for #{coin_name}"] }
    end
  end

  def return_amount(object = nil)
    object ||= trade
    if buy?
      object.amount_bought -= amount_was
      object.price_bought -= (amount_was * price_was)
    elsif sell?
      object.amount_sold -= amount_was
      object.price_sold -= (amount_was * price_was)
    end
    self.update_column :btc_amount, (amount * price)
  end

  def add_amount(object = nil)
    object ||= trade
    if buy?
      object.amount_bought += amount
      object.price_bought += btc_amount
    elsif sell?
      object.amount_sold += amount
      object.price_sold += btc_amount
    end
    self.update_column :btc_amount, (amount * price)
  end

  def return_amount_and_save(object = nil)
    object ||= trade
    return_amount object
    object.recount_values
    object.save!
  end

  def add_amount_and_save(object = nil)
    object ||= trade
    add_amount object
    object.recount_values
    object.save!
  end

  def update_round_values
    Round.transaction do
      return_amount round
      add_amount_and_save round
    end
  end

  def update_round(new_round_number)
    Round.transaction do
      if round
        return_amount_and_save round
        if round.amount_bought < 0.01 && round.amount_sold < 0.01
          round.destroy
        end
      end
      new_round = Round.where(user_id: self.user_id, coin_id: self.coin_id, round_number: new_round_number).first_or_initialize
      self.add_amount_and_save new_round
      new_round.save!
      self.update_attribute :round_id, new_round.id
      self.trade.add_rounds(new_round_number)
    end
  end

  private

  def buy?
    order_type == 'Buy'
  end

  def sell?
    order_type == 'Sell'
  end

  def round_have_only_this_record?
    (buy? && round.amount_bought == amount) || (sell? && round.amount_sold == amount)
  end

  def decrease_values_of_round_and_trade
    return true  unless round

    if round_have_only_this_record?
      round.destroy
    else
      return_amount_and_save round
    end
    
    return_amount_and_save trade
    user.refund_order amount * price, sell?
  end


end
