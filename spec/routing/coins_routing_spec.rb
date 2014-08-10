require "spec_helper"

RSpec.describe CoinsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/coins").to route_to("coins#index")
    end

    it "routes to #new" do
      expect(:get => "/coins/new").to route_to("coins#new")
    end

    it "routes to #show" do
      expect(:get => "/coins/1").to route_to("coins#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/coins/1/edit").to route_to("coins#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/coins").to route_to("coins#create")
    end

    it "routes to #update" do
      expect(:put => "/coins/1").to route_to("coins#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/coins/1").to route_to("coins#destroy", :id => "1")
    end

  end
end
