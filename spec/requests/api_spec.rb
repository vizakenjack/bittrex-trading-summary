require 'rails_helper'

RSpec.describe "Api", :type => :request do
  describe "GET /api" do
    it "works! (now write some real specs)" do
      get api_index_path
      expect(response.status).to be(200)
    end
  end
end
