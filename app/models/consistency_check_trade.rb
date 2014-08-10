module ConsistencyCheckTrade
  def consistency_check
    count_amount = -> (e) { e.inject(0) {|i,e| i + e.amount } }
    count_price = -> (e) { e.inject(0) {|i,e| i + (e.price * e.amount) } }

    buy_orders = orders_histories.select { |e| e.order_type == "Buy" }
    sell_orders = orders_histories.select { |e| e.order_type == "Sell" }
    @total_bought = count_amount.call buy_orders
    @total_sold = count_amount.call sell_orders
    @total_price_bought = count_price.call buy_orders
    @total_price_sold = count_price.call sell_orders
    @total_profit = @total_price_sold - @total_price_bought

    met_conditions
  end

  def rounds_check
    loaded_rounds = all_rounds
    injecter = -> (e, field) { e.inject(0) {|i,e| i + e[field] } }
    @total_bought = injecter.call loaded_rounds, :amount_bought
    @total_price_bought = injecter.call loaded_rounds, :price_bought
    @total_sold = injecter.call loaded_rounds, :amount_sold
    @total_price_sold = injecter.call loaded_rounds, :price_sold
    @total_profit = injecter.call loaded_rounds, :profit

    met_conditions
  end

  def user_check
    reloaded_user = self.user.reload
    trades = reloaded_user.trades.all
    injecter = -> (e, field) { e.inject(0) {|i,e| i + e[field] } }
    @total_price_bought = injecter.call trades, :price_bought
    @total_price_sold = injecter.call trades, :price_sold
    @total_profit = injecter.call trades, :profit

    if @total_price_bought != user.btc_invested
      "Invalid btc_invested! Current: #{@total_price_bought}, need: #{user.btc_invested}" 
    elsif @total_price_sold != user.btc_received
      "Invalid btc_received! Current: #{@total_price_sold}, need: #{user.btc_received}" 
    elsif @total_profit != user.trade_profit
      "Invalid profit! Current: #{@total_profit}, need: #{user.trade_profit}" 
    else
      true
    end
  end

  private

  def met_conditions
    if @total_bought != self.amount_bought
      "Invalid total_bought! Current: #{@total_bought}, need: #{self.amount_bought}" 
    elsif @total_sold != self.amount_sold
      "Invalid total_sold! Current: #{@total_sold}, need: #{self.amount_sold}"
    elsif @total_price_bought.round(5) != self.price_bought.round(5)
      "Invalid total_price_bought! Current: #{@total_price_bought.round(5)}, need: #{self.price_bought.round(5)}"
    elsif @total_price_sold.round(5) != self.price_sold.round(5)
      "Invalid total_price_sold! Current: #{@total_price_sold.round(5)}, need: #{self.price_sold.round(5)}"
    elsif @total_profit.round(5) != self.profit.round(5)
      "Invalid total_profit! Current: #{@total_profit.round(5)}, need: #{self.profit.round(5)} "
    else
      true
    end
  end
end