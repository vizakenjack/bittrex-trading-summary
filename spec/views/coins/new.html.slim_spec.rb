require 'spec_helper'

RSpec.describe "coins/new", :type => :view do
  before(:each) do
    assign(:coin, Coin.new(
      :name => "MyString",
      :tag => "MyString",
      :thread => "MyString",
      :current_price => 1.5,
      :current_volume => 1.5
    ))
  end

  it "renders new coin form" do
    render

    assert_select "form[action=?][method=?]", coins_path, "post" do

      assert_select "input#coin_name[name=?]", "coin[name]"

      assert_select "input#coin_tag[name=?]", "coin[tag]"

      assert_select "input#coin_thread[name=?]", "coin[thread]"

      assert_select "input#coin_current_price[name=?]", "coin[current_price]"

      assert_select "input#coin_current_volume[name=?]", "coin[current_volume]"
    end
  end
end
