require 'spec_helper'

RSpec.describe "trades/show", :type => :view do
  before(:each) do
    @trade = assign(:trade, Trade.create!(
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

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/9.99/)
  end
end
