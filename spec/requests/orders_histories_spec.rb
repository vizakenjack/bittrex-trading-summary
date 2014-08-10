require 'spec_helper'

RSpec.describe "OrdersHistories", :type => :request do
  let!(:user) { FactoryGirl.create(:user) }
  let(:exchange) { FactoryGirl.create(:exchange) }
  let(:coin) { FactoryGirl.create(:coin) }
  let(:trade) { FactoryGirl.create(:trade, user: user, coin: coin) }
  let(:orders_history) { trade.orders_histories.first }
  let(:first_round) { Round.where(coin: coin, user: user, round_number: 1).first }
  let(:second_round) { Round.where(coin: coin, user: user, round_number: 2).first }

  def sign_in(user)
    post_via_redirect user_session_path, 'user[username]' => user.username, 'user[password]' => user.password
  end

  before(:each) do
    sign_in user
  end

  describe "DELETE /orders_histories/:id" do
    let(:manual_order) { trade.orders_histories.find{ |e| e.added_by == "Manual" } }

    before(:each) do
      delete orders_history_path(id: manual_order.id)
    end

    it "should redirect to trades path" do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(trade_path(id: trade.id, username: user.username.downcase))
    end

    it "should delete manual order" do
      expect(trade.reload.orders_histories.count).to eq(7)
    end

    it "should pass consistency check" do
      expect(trade.reload.consistency_check).to eq(true)
    end

    it "should pass rounds check" do
      expect(trade.reload.rounds_check).to eq(true)
    end

    it "should pass user check" do
      expect(trade.reload.user_check).to eq(true)
    end
  end

  describe "PATCH /orders_histories/:id" do
    let(:manual_order) { trade.orders_histories.find{ |e| e.added_by == "Manual" } }

    before(:each) do
      patch orders_history_path(id: manual_order.id, orders_history: {amount: 200})
    end

    it "should redirect to trades path" do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(trade_path(id: trade.id, username: user.username.downcase))
    end

    it "should edit manual order" do
      expect(manual_order.reload.amount).to eq(200)
    end

    it "should pass consistency check" do
      expect(trade.reload.consistency_check).to eq(true)
    end

    it "should pass rounds check" do
      expect(trade.reload.rounds_check).to eq(true)
    end

    it "should pass user check" do
      expect(trade.reload.user_check).to eq(true)
    end
  end

end
