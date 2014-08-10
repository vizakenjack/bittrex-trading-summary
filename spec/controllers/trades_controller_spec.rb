require 'spec_helper'

RSpec.describe TradesController, :type => :controller do

  let!(:user) { FactoryGirl.create(:user) }
  let(:coin) { FactoryGirl.create(:coin) }
  let!(:exchange) { FactoryGirl.create(:exchange) }
  let(:api) { FactoryGirl.create(:api, user: user, exchange: exchange) }
  let(:valid_session) { {} }

  before(:each) do
    sign_in user
  end

  describe "GET index" do
    subject { get :index }
    # before(:each) { subject}

    it "should render index page" do
      get :index, {}, valid_session
      expect(response).to render_template("index")
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    subject { post :create, { orders_history: { coin_id: [coin.id], exchange_id: exchange.id, api_id: api.id } }, valid_session }

    it "should redirect to trades" do
      expect(subject).to redirect_to(trades_path(username: user.username))
    end

    it "should have result" do
      subject
      expect(assigns(:result)).to eq({ status: :success, message: "Successfully added AXR." })
    end

    it "should have a round with trade" do
      subject
      trade = user.trades.first
      round = user.orders_histories.first.round
      expect(round).to be
      expect(round.amount_bought).to eq(trade.amount_bought)
      expect(round.amount_sold).to eq(trade.amount_sold)
    end

  end


  # describe "GET index" do
  #   it "assigns all trades as @trades" do
  #     trade = Trade.create! valid_attributes
  #     get :index, {}, valid_session
  #     expect(assigns(:trades)).to eq([trade])
  #   end
  # end

  # describe "GET show" do
  #   it "assigns the requested trade as @trade" do
  #     trade = Trade.create! valid_attributes
  #     get :show, {:id => trade.to_param}, valid_session
  #     expect(assigns(:trade)).to eq(trade)
  #   end
  # end

  # describe "GET new" do
  #   it "assigns a new trade as @trade" do
  #     get :new, {}, valid_session
  #     expect(assigns(:trade)).to be_a_new(Trade)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested trade as @trade" do
  #     trade = Trade.create! valid_attributes
  #     get :edit, {:id => trade.to_param}, valid_session
  #     expect(assigns(:trade)).to eq(trade)
  #   end
  # end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new Trade" do
  #       expect {
  #         post :create, {:trade => valid_attributes}, valid_session
  #       }.to change(Trade, :count).by(1)
  #     end

  #     it "assigns a newly created trade as @trade" do
  #       post :create, {:trade => valid_attributes}, valid_session
  #       expect(assigns(:trade)).to be_a(Trade)
  #       expect(assigns(:trade)).to be_persisted
  #     end

  #     it "redirects to the created trade" do
  #       post :create, {:trade => valid_attributes}, valid_session
  #       expect(response).to redirect_to(Trade.last)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved trade as @trade" do
  #       post :create, {:trade => invalid_attributes}, valid_session
  #       expect(assigns(:trade)).to be_a_new(Trade)
  #     end

  #     it "re-renders the 'new' template" do
  #       post :create, {:trade => invalid_attributes}, valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested trade" do
  #       trade = Trade.create! valid_attributes
  #       put :update, {:id => trade.to_param, :trade => new_attributes}, valid_session
  #       trade.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested trade as @trade" do
  #       trade = Trade.create! valid_attributes
  #       put :update, {:id => trade.to_param, :trade => valid_attributes}, valid_session
  #       expect(assigns(:trade)).to eq(trade)
  #     end

  #     it "redirects to the trade" do
  #       trade = Trade.create! valid_attributes
  #       put :update, {:id => trade.to_param, :trade => valid_attributes}, valid_session
  #       expect(response).to redirect_to(trade)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the trade as @trade" do
  #       trade = Trade.create! valid_attributes
  #       put :update, {:id => trade.to_param, :trade => invalid_attributes}, valid_session
  #       expect(assigns(:trade)).to eq(trade)
  #     end

  #     it "re-renders the 'edit' template" do
  #       trade = Trade.create! valid_attributes
  #       put :update, {:id => trade.to_param, :trade => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested trade" do
  #     trade = Trade.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => trade.to_param}, valid_session
  #     }.to change(Trade, :count).by(-1)
  #   end

  #   it "redirects to the trades list" do
  #     trade = Trade.create! valid_attributes
  #     delete :destroy, {:id => trade.to_param}, valid_session
  #     expect(response).to redirect_to(trades_url)
  #   end
  # end

end
