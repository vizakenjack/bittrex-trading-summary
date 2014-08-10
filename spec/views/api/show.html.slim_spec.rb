require 'spec_helper'

RSpec.describe "api/show", :type => :view do
  before(:each) do
    @api = assign(:api, Api.create!(
      :user => nil,
      :exchange => nil,
      :key => "Key",
      :isecret => "secret"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/secret/)
  end
end
