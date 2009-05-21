require 'test_helper'

class MentorsControllerTest < ActionController::TestCase
  def setup
    @valid_mentor_attributes = Factory.attributes_for(:mentor)
    # @valid_mentor_instance = Factory.build(:mentor)
    # @valid_mentor = Factory.create(:mentor)
  end

  # I am redirecting index to new by default, there is no index
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mentor" do
    assert_difference('Mentor.count') do
      post :create, :mentor =>  @valid_mentor_attributes 
    end

    assert_redirected_to mentor_path(assigns(:mentor))
  end

  test "should show mentor" do
    get :show, :id => mentors(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => mentors(:one).to_param
    assert_response :success
  end

  test "should update mentor" do
    put :update, :id => mentors(:one).to_param, :mentor => { }
    assert_redirected_to mentor_path(assigns(:mentor))
  end

  test "should destroy mentor" do
    assert_difference('Mentor.count', -1) do
      delete :destroy, :id => mentors(:one).to_param
    end

    assert_redirected_to mentors_path
  end
end
