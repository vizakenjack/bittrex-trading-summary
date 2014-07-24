class UpdateUserInfo < ActiveRecord::Migration
  def change
    User.all.each do |user|
      trades = user.trades
      if trades.any?
        User.transaction do
          trades.each do |trade|
            user.btc_invested += trade.price_bought
            user.btc_received += trade.price_sold
            user.trade_profit += trade.sold_more? ? trade.actual_sold : (trade.profit)
          end
          user.save!
        end
      end
    end
  end
end
