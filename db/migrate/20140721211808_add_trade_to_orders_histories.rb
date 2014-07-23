class AddTradeToOrdersHistories < ActiveRecord::Migration
  def change
    add_reference :orders_histories, :trade, index: true
  end
end
