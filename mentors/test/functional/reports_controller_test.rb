require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  def setup
    @valid_mentor_attributes = Factory.attributes_for(:mentor)
    @valid_referral_attributes = Factory.attributes_for(:referral)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get mentors report" do
    Mentor.create!(@valid_mentor_attributes)

    get :mentors_excel
    assert_response :success
    assert_match(/What Skills Bring You/, @response.body)
    assert_match(/First Last/, @response.body)
    assert_match(/2706 S. Jackson Street/, @response.body)
    assert_match(/first\@last\.com/, @response.body)
  end

  test "should get referrals report" do
    Referral.create!(@valid_referral_attributes)

    get :referrals_excel

    assert_response :success
    assert_match(/RFirst RLast/, @response.body)
    assert_match(/Seattle/, @response.body)
    assert_match(/rfirst@rlast.com/, @response.body)
    assert_match(/MyText/, @response.body)
  end
end
