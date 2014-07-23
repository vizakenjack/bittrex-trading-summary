class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.references :user, index: true, null: false
      t.references :coin, index: true, null: false
      # t.references :exchange, index: true
      t.float :amount_bought, null: false, default: 0.0
      t.float :price_bought, null: false, default: 0.0
      t.float :amount_sold, null: false, default: 0.0
      t.float :price_sold, null: false, default: 0.0
      t.float :amount_left, null: false, default: 0.0
      t.float :amount_value, null: false, default: 0.0
      t.float :profit, null: false, default: 0.0
      t.float :percent, null: false, default: 0.0

      t.timestamps
    end
  end
end
