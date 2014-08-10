require 'spec_helper'

RSpec.describe "orders_histories/show", :type => :view do
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

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
  end
end
