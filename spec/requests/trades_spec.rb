require 'spec_helper'
RSpec.describe "Trades", :type => :request do
  let!(:user) { FactoryGirl.create(:user) }



  def sign_in(user)
    post_via_redirect user_session_path, 'user[username]' => user.username, 'user[password]' => user.password
  end

  before(:each) do
    sign_in user
  end

  describe "GET index" do

    it "should render index page" do
      get trades_path
      expect(response).to render_template("index")
      expect(response).to have_http_status(200)
    end
  end
end
