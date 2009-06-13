require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  def setup
    :activate_authlogic
    @user = Factory.build(:valid_user)
  end

  test "create a user session" do
    assert UserSession.create(@user)
  end
end
