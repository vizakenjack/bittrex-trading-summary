class AddDeletedAtToOrdersHistories < ActiveRecord::Migration
  def change
    add_column :orders_histories, :deleted_at, :datetime
    add_index :orders_histories, :deleted_at
  end
end
