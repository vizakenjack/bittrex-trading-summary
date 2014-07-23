class CreateOrdersHistories < ActiveRecord::Migration
  def change
    create_table :orders_histories do |t|
      t.references :user, index: true, null: false
      t.references :coin, index: true, null: false
      t.references :exchange, index: true, null: false
      t.integer :order_type, null: false, default: 0
      t.float :amount, null: false, default: 0.0
      t.float :price, null: false, default: 0.0

      t.timestamps
    end
  end
end
