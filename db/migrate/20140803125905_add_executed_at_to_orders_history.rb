class AddExecutedAtToOrdersHistory < ActiveRecord::Migration
  def change
    add_column :orders_histories, :executed_at, :datetime
  end
  OrdersHistory.update_all "executed_at = created_at"
end
