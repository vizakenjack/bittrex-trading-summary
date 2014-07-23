class AddNameToApi < ActiveRecord::Migration
  def change
    add_column :api, :name, :string
  end
end
