require 'test_helper'

class ReferralsControllerTest < ActionController::TestCase
  def setup
    @referral = Factory.create(:good_referral)
    @valid_referral_attributes = Factory.attributes_for(:referral)
  end

  # index aliases to new
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create referral" do
    assert_difference('Referral.count') do
      post :create, :referral => @valid_referral_attributes
    end

    assert_redirected_to referral_path(assigns(:referral))
  end

  test "should show referral" do
    get :show, :id => @referral.id.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @referral.id.to_param
    assert_response :success
  end

  test "should update referral" do
    put :update, :id => @referral.id.to_param, :referral => { }
    assert_redirected_to referral_path(assigns(:referral))
  end

  test "should destroy referral" do
    assert_difference('Referral.count', -1) do
      delete :destroy, :id => @referral.id.to_param
    end

    assert_redirected_to referrals_path
  end
end
