require 'spec_helper'

RSpec.describe "Coins", :type => :request do
  describe "GET /coins" do
    it "works! (now write some real specs)" do
      get coins_path
      expect(response.status).to be(200)
    end
  end
end
