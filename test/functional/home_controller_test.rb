require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get user" do
    get :user
    assert_response :success
  end

end
