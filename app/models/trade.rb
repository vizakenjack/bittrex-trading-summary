class Trade < ActiveRecord::Base
  has_many :orders_histories, dependent: :destroy
  belongs_to :user
  belongs_to :coin
  acts_as_paranoid

  def self.create_new(coin, user_id)
    trade = nil
    trade = self.where(coin_id: coin[:id], user_id: user_id).first_or_initialize
    trade.update(coin)
    trade
  end

  def update(coin)
    self.amount_bought += coin[:amount_bought]
    self.price_bought += coin[:btc_amount_bought]
    self.amount_sold += coin[:amount_sold]
    self.price_sold += coin[:btc_amount_sold]

    self.last_trade = coin[:last_trade]  if last_trade == nil or coin[:last_trade] > self.last_trade

    self.average_price_sold = self.price_sold / self.amount_sold  if self.amount_sold > 0
    self.average_price_bought = self.price_bought / self.amount_bought  if self.amount_bought > 0
    self.amount_left = self.amount_bought - self.amount_sold
    self.amount_left = 0  if self.amount_left < 0.001
    self.amount_value = self.amount_left * self.average_price_bought
    self.profit = self.price_sold - self.price_bought
    self.percent = self.price_bought == 0 ? 100.0 : (self.price_sold / self.price_bought) * 100
    self.save!
  end

  def sold_more?
    @sold ||= amount_sold > amount_bought and amount_bought > 0
  end

  def actual_sold
    amount_bought * average_price_sold - amount_bought * average_price_bought
  end
end
