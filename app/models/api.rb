class Api < ActiveRecord::Base
  belongs_to :user
  belongs_to :exchange

  before_save :strip_whitespace

  validates :key, presence: true, uniqueness: true, length: { minimum: 6 }, :format => { :with => /\A[a-z0-9\s]+\z/i }
  validates :secret, uniqueness: true, length: { minimum: 6 }, :format => { :with => /\A[a-z0-9\s]+\z/i }
  validates :name, presence: true, length: { in: 2..14 }

  def strip_whitespace
    self.key.gsub!(/\s+/, '')
    self.secret.gsub!(/\s+/, '')
    self.name.gsub!(/\s+/, '')
  end

  def sync
    results = []
    return false  unless trx = Bittrex.new(key, secret)
    return false  unless history = trx.order_history(nil, 500)
    coin_tags = history.collect{|e| e['Exchange'].split("-")[1]}.uniq
    coin_tags.each do |coin_tag|
      coin = Coin.find_by(tag: coin_tag)
      history = trx.order_history(coin.tag, 500)
      results << OrdersHistory.add_from_api(coin, exchange_id, user_id, history)
    end
    results
  end

  def self.system
    ## FIX ME ##
    self.first
  end

end
