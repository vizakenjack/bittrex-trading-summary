require 'spec_helper'

RSpec.describe "exchanges/new", :type => :view do
  before(:each) do
    assign(:exchange, Exchange.new(
      :name => "MyString",
      :short_name => "MyString",
      :url => "MyString"
    ))
  end

  it "renders new exchange form" do
    render

    assert_select "form[action=?][method=?]", exchanges_path, "post" do

      assert_select "input#exchange_name[name=?]", "exchange[name]"

      assert_select "input#exchange_short_name[name=?]", "exchange[short_name]"

      assert_select "input#exchange_url[name=?]", "exchange[url]"
    end
  end
end
