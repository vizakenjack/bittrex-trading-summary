require 'spec_helper'

RSpec.describe "coins/index", :type => :view do
  before(:each) do
    assign(:coins, [
      Coin.create!(
        :name => "Name",
        :tag => "Tag",
        :thread => "Thread",
        :current_price => 1.5,
        :current_volume => 1.5
      ),
      Coin.create!(
        :name => "Name",
        :tag => "Tag",
        :thread => "Thread",
        :current_price => 1.5,
        :current_volume => 1.5
      )
    ])
  end

  it "renders a list of coins" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Tag".to_s, :count => 2
    assert_select "tr>td", :text => "Thread".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
