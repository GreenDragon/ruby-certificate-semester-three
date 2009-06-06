require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  def setup
    @valid_mentor_attributes = Factory.attributes_for(:mentor)
  end

  test "should get excel report" do
    get :excel
    assert_response :success
  end

  test "should get mentors report" do
    Mentor.create!(@valid_mentor_attributes)

    get :mentor_report
    assert_response :success
    assert_match(/What Skills Bring You/, @response.body)
    assert_match(/First Last/, @response.body)
    assert_match(/2706 S. Jackson Street/, @response.body)
    assert_match(/first\@last\.com/, @response.body)
  end
end
