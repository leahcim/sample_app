require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    # The test automatically follows the redirect to the signin page.
    integration_sign_in(user)
    # The test follows a redirect again, this time to users/edit.
    response.should render_template('users/edit')
  end
end
