require 'spec_helper'

RSpec.describe "trades/index", :type => :view do
  before(:each) do
    assign(:trades, [
      Trade.create!(
        :user => nil,
        :coin => nil,
        :exchange => nil,
        :amount_bought => 1.5,
        :price_bought => 1.5,
        :amount_sold => 1.5,
        :price_sold => 1.5,
        :amount_left => 1.5,
        :amount_value => 1.5,
        :profit => 1.5,
        :percent => "9.99"
      ),
      Trade.create!(
        :user => nil,
        :coin => nil,
        :exchange => nil,
        :amount_bought => 1.5,
        :price_bought => 1.5,
        :amount_sold => 1.5,
        :price_sold => 1.5,
        :amount_left => 1.5,
        :amount_value => 1.5,
        :profit => 1.5,
        :percent => "9.99"
      )
    ])
  end

  it "renders a list of trades" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
