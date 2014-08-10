class AddRoundIdToOrdersHistoriesAndTrades < ActiveRecord::Migration
  def change
    add_column :orders_histories, :round_number, :integer, null: false, default: 1, index: true
    add_column :orders_histories, :round_id, :integer, index: true
    add_column :trades, :round_number, :integer, index: true
    add_column :trades, :current_round_number, :integer
    add_column :trades, :rounds, :integer, array: true

    reversible do |dir|
      dir.up do
        Trade.where("round_number IS NOT NULL").delete_all
        Trade.update_all("current_round_number = 1")
        OrdersHistory.update_all round_number: 1
        trades = Trade.all
        trades.each do |record|
            record.rounds = [1]
            record.save
            round = record.dup.becomes(Round)
            round.round_number = 1
            round.current_round_number = nil
            round.rounds = nil
            round.save

            OrdersHistory.where(user_id: record.user_id, coin_id: record.coin_id).update_all("round_id = #{round.id}")
        end
      end
    end
  end

end
