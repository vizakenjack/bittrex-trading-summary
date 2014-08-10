require 'spec_helper'

RSpec.describe "orders_histories/index", :type => :view do
  before(:each) do
    assign(:orders_histories, [
      OrdersHistory.create!(
        :user => nil,
        :coin => nil,
        :exchange => nil,
        :order_type => 1,
        :amount => 1.5,
        :price => 1.5
      ),
      OrdersHistory.create!(
        :user => nil,
        :coin => nil,
        :exchange => nil,
        :order_type => 1,
        :amount => 1.5,
        :price => 1.5
      )
    ])
  end

  it "renders a list of orders_histories" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
