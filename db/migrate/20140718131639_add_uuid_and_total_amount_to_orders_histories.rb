class AddUuidAndTotalAmountToOrdersHistories < ActiveRecord::Migration
  def change
    add_column :orders_histories, :uuid, :string, index: true, before: :coin_id, unique: true
    add_column :orders_histories, :total_amount, :float, null: false, default: 0
  end
end
