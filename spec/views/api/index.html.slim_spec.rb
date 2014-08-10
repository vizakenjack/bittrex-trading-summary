require 'spec_helper'

RSpec.describe "api/index", :type => :view do
  before(:each) do
    assign(:api, [
      Api.create!(
        :user => nil,
        :exchange => nil,
        :key => "Key",
        :secret => "secret"
      ),
      Api.create!(
        :user => nil,
        :exchange => nil,
        :key => "Key",
        :secret => "secret"
      )
    ])
  end

  it "renders a list of api" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    assert_select "tr>td", :text => "secret".to_s, :count => 2
  end
end
