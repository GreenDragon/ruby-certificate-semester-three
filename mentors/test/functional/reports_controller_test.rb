require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get excel report" do
    get :excel
    assert_response :success
  end
end
