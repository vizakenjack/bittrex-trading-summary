require 'spec_helper'

RSpec.describe "coins/show", :type => :view do
  before(:each) do
    @coin = assign(:coin, Coin.create!(
      :name => "Name",
      :tag => "Tag",
      :thread => "Thread",
      :current_price => 1.5,
      :current_volume => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Tag/)
    expect(rendered).to match(/Thread/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
  end
end
