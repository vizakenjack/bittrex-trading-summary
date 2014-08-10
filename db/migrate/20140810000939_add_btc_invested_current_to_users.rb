class AddBtcInvestedCurrentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :btc_investing, :float, null: false, default: 0.0
  end
end
