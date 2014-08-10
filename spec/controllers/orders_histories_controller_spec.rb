require 'spec_helper'

RSpec.describe OrdersHistoriesController, :type => :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:exchange) { FactoryGirl.create(:exchange) }
  let(:coin) { FactoryGirl.create(:coin) }
  let(:trade) { FactoryGirl.create(:trade, user: user, coin: coin) }
  let(:orders_history) { trade.orders_histories.first }
  let(:first_round) { Round.where(coin: coin, user: user, round_number: 1).first }
  let(:second_round) { Round.where(coin: coin, user: user, round_number: 2).first }

  let(:valid_session) { {} }

  before(:each) do
    sign_in user
  end

  describe "update orders_history round" do
    subject { patch :update, { id: orders_history.id, orders_history: { round_number: 2 } }, valid_session }

    before(:each) do
      subject
    end

    it "should redirect to trades" do
      should redirect_to(trade_path(id: trade.id, username: user.username.downcase))
    end

    it "should create round 2" do
      expect(second_round).to be
      expect(second_round.current_round_number).to be_nil
    end

    it "should reduce amount from round 1" do
      expect(first_round.amount_sold).to eq(60)
    end

    it "should add amount to round 2" do
      expect(second_round.amount_sold).to eq(30)
    end

    it "should remain amount of trade" do
      expect(trade.reload.amount_sold).to eq(90)
    end
  end

  describe "delete orders_history" do
    let(:another_user) { FactoryGirl.create(:test)}
    let(:another_order) {
      another_order = trade.orders_histories.first
      another_order.update_attribute(:user_id, another_user.id)
      another_order
    }
    let(:manual_order) { trade.orders_histories.find{ |e| e.added_by == "Manual" } }

    it "should NOT allow to delete API history" do
      delete :destroy, { id: orders_history.id }, valid_session
      expect(response).to render_template('templates/error')
      expect(response).to have_http_status(403)
    end

    it "should NOT allow to delete not your orders_history" do
      delete :destroy, { id: another_order.id }, valid_session
      expect(response).to render_template('templates/error')
      expect(response).to have_http_status(403)
    end

    it "should redirect after deleting manual order" do
      delete :destroy, { id: manual_order.id }, valid_session
      expect(response).to redirect_to(trade_path(id: trade.id, username: user.username.downcase))
      expect(response).to have_http_status(302)
    end

  end

end
