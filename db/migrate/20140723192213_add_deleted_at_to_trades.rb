class AddDeletedAtToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :deleted_at, :datetime
    add_index :trades, :deleted_at
  end
end
