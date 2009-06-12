require 'test_helper'

class MentorsControllerTest < ActionController::TestCase
  def setup
    @mentor = Factory.create(:mentor)
    @valid_mentor_attributes = Factory.attributes_for(:good_mentor)
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
    get :show, :id => @mentor.id.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @mentor.id.to_param
    assert_response :success
  end

  test "should update mentor" do
    put :update, :id => @mentor.id.to_param, :mentor => { }
    assert_redirected_to mentor_path(assigns(:mentor))
  end

  test "should destroy mentor" do
    assert post :create, :mentor =>  @valid_mentor_attributes
    assert_difference('Mentor.count', -1) do
      delete :destroy, :id => @mentor.id.to_param
    end

    assert_redirected_to mentors_path
  end

  test "should raise Geocoder error when address malformed" do
    @invalid_mentor_attributes = Factory.attributes_for(:bad_mentor)
    post :create, :mentor => @invalid_mentor_attributes

    assert_match(/Could not Geocode address/, @response.body)
  end

  test "should geocode known address properly" do
    assert_difference('Mentor.count') do
      post :create, :mentor =>  @valid_mentor_attributes
    end

    assert_not_nil Mentor.find(:last).lat
    assert_not_nil Mentor.find(:last).lng
  end
end
