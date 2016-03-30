class OrdersHistoriesController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :set_orders_history, only: [:edit, :update, :destroy]
  respond_to :html, :js

  # GET /orders_histories/1/edit
  def edit
    authorize! :edit, @orders_history
  end

  # PATCH/PUT /orders_histories/1
  # PATCH/PUT /orders_histories/1.json
  def update
    # todo: fix cancan
    authorize! :update, @orders_history  unless @orders_history.round_number_changed?
    @orders_history.assign_attributes(orders_history_params)
    @orders_history.update_round(orders_history_params["round_number"])  if @orders_history.valid? && @orders_history.round_number_changed?
    respond_to do |format|
      if @orders_history.save
        format.html { redirect_to trade_path_with_username(@orders_history.trade), notice: 'Orders history was successfully updated.' }
        format.json { render json: {success: true, round: params[:orders_history][:round_number]}  }
      else
        format.html { render :edit }
        # format.json { render json: @orders_history.errors, status: :unprocessable_entity }
        format.json { render text: @orders_history.errors.full_messages.join(","), status: 403 }
      end
    end
  end

  # DELETE /orders_histories/1
  # DELETE /orders_histories/1.json
  def destroy
    authorize! :destroy, @orders_history
    trade_id = @orders_history.trade_id
    @orders_history.destroy
    respond_to do |format|
      format.html { redirect_to trade_path_with_username(@orders_history.trade), notice: 'Orders history was successfully deleted.' }
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
      params.require(:orders_history).permit(
        :user_id, 
        :coin_id, 
        :exchange_id, 
        :round_number,
        :order_type, 
        :amount, 
        :price, 
        :uuid, 
        :btc_amount, 
        :added_by
      )
    end
end
