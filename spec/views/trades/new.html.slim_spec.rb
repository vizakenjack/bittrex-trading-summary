require 'spec_helper'

RSpec.describe "trades/new", :type => :view do
  before(:each) do
    assign(:trade, Trade.new(
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
    ))
  end

  it "renders new trade form" do
    render

    assert_select "form[action=?][method=?]", trades_path, "post" do

      assert_select "input#trade_user_id[name=?]", "trade[user_id]"

      assert_select "input#trade_coin_id[name=?]", "trade[coin_id]"

      assert_select "input#trade_exchange_id[name=?]", "trade[exchange_id]"

      assert_select "input#trade_amount_bought[name=?]", "trade[amount_bought]"

      assert_select "input#trade_price_bought[name=?]", "trade[price_bought]"

      assert_select "input#trade_amount_sold[name=?]", "trade[amount_sold]"

      assert_select "input#trade_price_sold[name=?]", "trade[price_sold]"

      assert_select "input#trade_amount_left[name=?]", "trade[amount_left]"

      assert_select "input#trade_amount_value[name=?]", "trade[amount_value]"

      assert_select "input#trade_profit[name=?]", "trade[profit]"

      assert_select "input#trade_percent[name=?]", "trade[percent]"
    end
  end
end
