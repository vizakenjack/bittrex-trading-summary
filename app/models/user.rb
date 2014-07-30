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


end
