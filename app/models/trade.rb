# NULL - :round_number, index: true
# INTEGER - :current_round_number
# ARRAY - :rounds, array: true

class Trade < ActiveRecord::Base
  include ConsistencyCheckTrade
  has_many :orders_histories, dependent: :destroy
  belongs_to :user
  belongs_to :coin

  after_create :create_round

  before_destroy :delete_rounds
  before_destroy :reduce_user_values
  after_destroy :soft_delete_orders_histories

  default_scope { where("round_number IS NULL") }

  BTC_THRESHOLD = 0.001

  def add_values(coin_hash)
    self.amount_bought += coin_hash[:amount_bought]
    self.price_bought += coin_hash[:btc_amount_bought]
    self.amount_sold += coin_hash[:amount_sold]
    self.price_sold += coin_hash[:btc_amount_sold]

    self.last_trade = coin_hash[:last_trade]  if self.last_trade == nil or coin_hash[:last_trade] > self.last_trade

    recount_values
    self.save!
    self
  end

  def recount_values
    self.average_price_sold = self.price_sold / self.amount_sold  if self.amount_sold > 0
    self.average_price_bought = self.price_bought / self.amount_bought  if self.amount_bought > 0
    self.amount_left = self.amount_bought - self.amount_sold
    self.amount_left = 0  if self.amount_left < BTC_THRESHOLD
    self.amount_value = self.amount_left * self.average_price_bought
    self.profit = self.price_sold - self.price_bought
    self.percent = self.price_bought == 0 ? 100.0 : (self.price_sold / self.price_bought) * 100
  end

  def sold_more?
    self.amount_sold > self.amount_bought and self.amount_bought > 0
  end

  def actual_sold
    self.amount_bought * self.average_price_sold - self.amount_bought * self.average_price_bought
  end

  def load_orders_histories
    orders_histories.includes(:exchange, :coin, :user).order("executed_at DESC")
  end


  def add_rounds(number)
    rounds_will_change! # BIG BAD VOODOO MAGIC
    update_attributes rounds: self.rounds.push(number.to_i).uniq.sort
  end

  def all_rounds
    Round.where(user_id: user.id, coin_id: coin.id, round_number: rounds).all
  end


  private

  def reduce_user_values
    user.btc_invested -= self.price_bought
    user.btc_received -= self.price_sold
    user.trade_profit -= sold_more? ? actual_sold : self.profit
    user.save!
  end

  def delete_rounds
    Round.where(user_id: self.user_id, coin_id: self.coin_id).delete_all
  end

  def soft_delete_orders_histories
    orders_histories.update_all("deleted_at = '#{Time.now}'")
  end

  def create_round
    round = self.dup.becomes(Round)
    self.current_round_number = 1
    self.rounds = [1]
    self.save!

    round.round_number = 1
    round.current_round_number = nil
    round.rounds = nil
    round.save!
  end
end
