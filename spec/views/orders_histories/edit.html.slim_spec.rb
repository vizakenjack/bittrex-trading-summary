require 'spec_helper'

RSpec.describe "orders_histories/edit", :type => :view do
  before(:each) do
    @orders_history = assign(:orders_history, OrdersHistory.create!(
      :user => nil,
      :coin => nil,
      :exchange => nil,
      :order_type => 1,
      :amount => 1.5,
      :price => 1.5
    ))
  end

  it "renders the edit orders_history form" do
    render

    assert_select "form[action=?][method=?]", orders_history_path(@orders_history), "post" do

      assert_select "input#orders_history_user_id[name=?]", "orders_history[user_id]"

      assert_select "input#orders_history_coin_id[name=?]", "orders_history[coin_id]"

      assert_select "input#orders_history_exchange_id[name=?]", "orders_history[exchange_id]"

      assert_select "input#orders_history_order_type[name=?]", "orders_history[order_type]"

      assert_select "input#orders_history_amount[name=?]", "orders_history[amount]"

      assert_select "input#orders_history_price[name=?]", "orders_history[price]"
    end
  end
end
