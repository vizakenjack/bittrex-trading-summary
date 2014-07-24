class AddCoinParamsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :btc_invested, :float, null: false, default: 0.0
    add_column :users, :btc_received, :float, null: false, default: 0.0
    add_column :users, :trade_profit, :float, null: false, default: 0.0
    add_column :users, :orders_histories_count, :integer, null: false, default: 0
  end

end
