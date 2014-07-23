require 'rails_helper'

RSpec.describe "api/new", :type => :view do
  before(:each) do
    assign(:api, Api.new(
      :user => nil,
      :exchange => nil,
      :key => "MyString",
      :secret => "MyString"
    ))
  end

  it "renders new api form" do
    render

    assert_select "form[action=?][method=?]", api_index_path, "post" do

      assert_select "input#api_user_id[name=?]", "api[user_id]"

      assert_select "input#api_exchange_id[name=?]", "api[exchange_id]"

      assert_select "input#api_key[name=?]", "api[key]"

      assert_select "input#api_secret[name=?]", "api[secret]"
    end
  end
end
