require 'spec_helper'

RSpec.describe "api/edit", :type => :view do
  before(:each) do
    @api = assign(:api, Api.create!(
      :user => nil,
      :exchange => nil,
      :key => "MyString",
      :secret => "MyString"
    ))
  end

  it "renders the edit api form" do
    render

    assert_select "form[action=?][method=?]", api_path(@api), "post" do

      assert_select "input#api_user_id[name=?]", "api[user_id]"

      assert_select "input#api_exchange_id[name=?]", "api[exchange_id]"

      assert_select "input#api_key[name=?]", "api[key]"

      assert_select "input#api_id_api[name=?]", "api[id_api]"
    end
  end
end
