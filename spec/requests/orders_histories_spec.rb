require 'rails_helper'

RSpec.describe "OrdersHistories", :type => :request do
  describe "GET /orders_histories" do
    it "works! (now write some real specs)" do
      get orders_histories_path
      expect(response.status).to be(200)
    end
  end
end
