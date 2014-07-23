class CreateCoins < ActiveRecord::Migration
  def change
    create_table :coins do |t|
      t.string :name, null: false
      t.string :tag, null: false
      t.string :thread
      t.float :current_price, null: false, default: 0.0
      t.float :current_volume, null: false, default: 0.0

      t.timestamps
    end
  end
end
