class CreateApi < ActiveRecord::Migration
  def change
    create_table :api do |t|
      t.references :user, index: true, null: false
      t.references :exchange, index: true, null: false
      t.string :key, null: false
      t.string :secret

      t.timestamps
    end
  end
end
