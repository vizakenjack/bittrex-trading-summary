require 'spec_helper'

RSpec.describe "exchanges/edit", :type => :view do
  before(:each) do
    @exchange = assign(:exchange, Exchange.create!(
      :name => "MyString",
      :short_name => "MyString",
      :url => "MyString"
    ))
  end

  it "renders the edit exchange form" do
    render

    assert_select "form[action=?][method=?]", exchange_path(@exchange), "post" do

      assert_select "input#exchange_name[name=?]", "exchange[name]"

      assert_select "input#exchange_short_name[name=?]", "exchange[short_name]"

      assert_select "input#exchange_url[name=?]", "exchange[url]"
    end
  end
end
