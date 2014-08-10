require 'spec_helper'

RSpec.describe "Exchanges", :type => :request do
  describe "GET /exchanges" do
    it "works! (now write some real specs)" do
      get exchanges_path
      expect(response.status).to be(200)
    end
  end
end
