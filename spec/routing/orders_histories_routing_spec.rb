require "spec_helper"

RSpec.describe OrdersHistoriesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/orders_histories").to route_to("orders_histories#index")
    end

    it "routes to #new" do
      expect(:get => "/orders_histories/new").to route_to("orders_histories#new")
    end

    it "routes to #show" do
      expect(:get => "/orders_histories/1").to route_to("orders_histories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/orders_histories/1/edit").to route_to("orders_histories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/orders_histories").to route_to("orders_histories#create")
    end

    it "routes to #update" do
      expect(:put => "/orders_histories/1").to route_to("orders_histories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/orders_histories/1").to route_to("orders_histories#destroy", :id => "1")
    end

  end
end
