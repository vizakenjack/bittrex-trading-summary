require 'spec_helper'

RSpec.describe "exchanges/show", :type => :view do
  before(:each) do
    @exchange = assign(:exchange, Exchange.create!(
      :name => "Name",
      :short_name => "Short Name",
      :url => "Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Short Name/)
    expect(rendered).to match(/Url/)
  end
end
