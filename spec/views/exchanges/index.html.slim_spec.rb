require 'spec_helper'

RSpec.describe "exchanges/index", :type => :view do
  before(:each) do
    assign(:exchanges, [
      Exchange.create!(
        :name => "Name",
        :short_name => "Short Name",
        :url => "Url"
      ),
      Exchange.create!(
        :name => "Name",
        :short_name => "Short Name",
        :url => "Url"
      )
    ])
  end

  it "renders a list of exchanges" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Short Name".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
