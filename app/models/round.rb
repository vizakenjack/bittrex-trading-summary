# INTEGER - :round_number, index: true
# NULL - :current_round_number
# NULL - :rounds, array: true

class Round < Trade

  skip_callback :create, :after, :create_round
  skip_callback :destroy, :before, :reduce_user_values
  skip_callback :destroy, :before, :delete_rounds
  skip_callback :destroy, :after, :soft_delete_orders_histories

  before_destroy :remove_number_from_trade

  def self.default_scope
    self.where("round_number IS NOT NULL")
  end

  private

  def remove_number_from_trade
    trade = Trade.where(user_id: self.user.id, coin_id: self.coin_id).first
    trade.rounds = trade.rounds.reject {|e| e == self.round_number}
    trade.save!
  end

end