require "spec_helper"

RSpec.describe ApiController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api").to route_to("api#index")
    end

    it "routes to #new" do
      expect(:get => "/api/new").to route_to("api#new")
    end

    it "routes to #show" do
      expect(:get => "/api/1").to route_to("api#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/api/1/edit").to route_to("api#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api").to route_to("api#create")
    end

    it "routes to #update" do
      expect(:put => "/api/1").to route_to("api#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/1").to route_to("api#destroy", :id => "1")
    end

  end
end
