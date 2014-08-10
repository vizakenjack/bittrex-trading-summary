class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :coins
  has_many :api
  has_many :orders_histories
  has_many :trades
  default_scope { order('id DESC') } 

  enum role: {user: 0, admin: 10}

  attr_accessor :login
  
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }, length: { in: 2..14 }, \
            :format => { :with => /[a-z\d_\-\.]+/i }


  def add_new_trades
    recent_trade = self.trades.first
  end

  def all_trades
    trades.includes(:coin, :user).order("last_trade DESC").all
  end

  def self.update_all_stats
    users = self.includes(:trades).all
    users.update_all "btc_invested = 0.0, btc_received = 0.0, trade_profit = 0.0"

    users.each do |user|
      user.btc_invested = user.trades.inject(0){|i,e| i + e.price_bought }
      user.btc_investing = user.trades.inject(0){|i,e| i + e.amount_value }
      user.btc_received = user.trades.inject(0){|i,e| i + e.price_sold }
      user.trade_profit = user.btc_received - user.btc_invested
      user.save!
    end
  end

  def total_recount
    self.btc_invested = self.trades.inject(0){|i,e| i + e.price_bought }
    self.btc_investing = self.trades.inject(0){|i,e| i + e.amount_value }
    self.btc_received = self.trades.inject(0){|i,e| i + e.price_sold }
    self.trade_profit = self.btc_received - self.btc_invested
    save!
  end

  def recount_profit(coin_hash, trade)
    self.transaction do
      user.btc_invested += coin_hash.result[:btc_amount_bought]
      user.btc_received += coin_hash.result[:btc_amount_sold]
      user.trade_profit += trade.sold_more? ? trade.actual_sold : (trade.profit)
      user.save!
    end
  end


end
