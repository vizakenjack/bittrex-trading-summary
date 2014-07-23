class OrdersHistoriesController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :set_orders_history, only: [:edit, :update, :destroy]
  respond_to :html, :js

  # GET /orders_histories
  # GET /orders_histories.json
  # def index
  #   @orders_histories = OrdersHistory.all
  #   authorize! :read, @orders_histories
  #   redirect_to trades_path(username: current_user.username || @default_username)
  # end

  # # GET /orders_histories/1
  # # GET /orders_histories/1.json
  # def show
  # end

  # # GET /orders_histories/new
  # def new
  #   @orders_history = OrdersHistory.new
  # end



  # # POST /orders_histories
  # # POST /orders_histories.json
  # def create

  # end


  # GET /orders_histories/1/edit
  def edit
  end

  
  # PATCH/PUT /orders_histories/1
  # PATCH/PUT /orders_histories/1.json
  def update
    respond_to do |format|
      if @orders_history.update(orders_history_params)
        format.html { redirect_to trades_path(username: current_user.username || @default_username), notice: 'Orders history was successfully updated.' }
        format.json { render :show, status: :ok, location: trades_path(username: current_user.username || @default_username) }
      else
        format.html { render :edit }
        format.json { render json: @orders_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders_histories/1
  # DELETE /orders_histories/1.json
  def destroy
    @orders_history.destroy
    respond_to do |format|
      format.html { redirect_to trades_path(username: current_user.username || @default_username), notice: 'Orders history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_orders_history
      @orders_history = OrdersHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orders_history_params
      params.require(:orders_history).permit(:user_id, :coin_id, :exchange_id, :order_type, :amount, :price, :uuid, :btc_amount, :added_by)
    end
end
