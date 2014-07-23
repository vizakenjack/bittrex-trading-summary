class RenameTotalAmountToBtcAmount < ActiveRecord::Migration
  def change
    rename_column :orders_histories, :total_amount, :btc_amount
  end
end
