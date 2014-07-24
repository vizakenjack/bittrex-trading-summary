class TradesController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :set_trade, only: [:show, :edit, :update, :destroy]

  # GET /trades
  # GET /trades.json
  def index
    authorize! :read, Trade
    @orders_history = OrdersHistory.new
    user =  params[:username].present? ? User.find_by(username: params[:username]) : current_user
    @trades = user.trades.includes(:coin, :user).order("last_trade DESC").all
    @api = current_user.api  if signed_in?
  end

  # GET /trades/1
  # GET /trades/1.json
  def show
    authorize! :read, Trade
    @orders_histories = @trade.orders_histories.includes(:exchange, :coin, :user).order("created_at DESC")
  end

  # GET /trades/new
  def new
    authorize! :create, Trade
    @trade = Trade.new
  end

  # GET /trades/1/edit
  def edit
    authorize! :edit, Trade
  end

  # POST /trades
  # POST /trades.json
  def create
    authorize! :create, Trade
    if params[:orders_history][:api_id] and api = current_user.api.find(params[:orders_history][:api_id])
      trx = Bittrex.new(api.key, api.secret)
      coin = Coin.find(params[:orders_history][:coin_id])
      history = trx.order_history(coin.tag, 500)
      @result = OrdersHistory.add_from_api(coin, params[:orders_history][:exchange_id], current_user.id, history)
    else
      coin = Coin.find(params[:orders_history][:coin_id])
      @result = OrdersHistory.add_manual(current_user.id, orders_history_params)
    end

    respond_to do |format|
      format.html {
        if @result[:status] == :success
          redirect_to(trades_path(username: current_user.username), notice: "#{pluralize @result[:message], "order"} has been added.")
        else
          redirect_to(trades_path(username: current_user.username), alert: "Trade not saved: #{messages_to_list @result[:message]}")
        end
      }
    end
  end

  # PATCH/PUT /trades/1
  # PATCH/PUT /trades/1.json
  def update
    authorize! :edit, Trade
    respond_to do |format|
      if @trade.update(trade_params)
        format.html { redirect_to @trade, notice: 'Trade was successfully updated.' }
        format.json { render :show, status: :ok, location: @trade }
      else
        format.html { render :edit }
        format.json { render json: @trade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trades/1
  # DELETE /trades/1.json
  def destroy
    authorize! :destroy, Trade
    @trade.destroy
    respond_to do |format|
      format.html { redirect_to trades_url, notice: 'Trade was successfully destroyed.' }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade
      @trade = Trade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trade_params
      params.require(:trade).permit(:user_id, :coin_id, :exchange_id, :amount_bought, :price_bought, :amount_sold, :price_sold, :amount_left, :amount_value, :profit, :percent)
    end

    def orders_history_params
      params.require(:orders_history).permit(:coin_id, :exchange_id, :order_type, :amount, :price)
    end
end
