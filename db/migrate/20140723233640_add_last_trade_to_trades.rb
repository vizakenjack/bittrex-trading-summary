class AddLastTradeToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :last_trade, :datetime``
  end
end
