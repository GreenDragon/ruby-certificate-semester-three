require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "When getting new user view" do
    setup { get :new }

    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash

    # should_display_a_sign_up_form
  end

  context "Given valid attributes when creating a new user" do
    setup do
      post :create, :user => Factory.attributes_for(:valid_user)
    end

    should_set_the_flash_to "Account registered!"

    should_respond_with :redirect
    should_route :get, "/reports", :controller => :reports, :action => :index
  end

  context "Given invalid attributes when creating a new user" do
    setup do
      post :create, :user => Factory.attributes_for(:invalid_user)
    end

    should_render_template :new
    should_not_set_the_flash
  end

end
