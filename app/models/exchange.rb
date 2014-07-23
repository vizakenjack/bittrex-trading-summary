class Exchange < ActiveRecord::Base
  has_many :coins
  has_many :orders_histories
  has_many :trades
end
