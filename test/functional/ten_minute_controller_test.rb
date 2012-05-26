require 'test_helper'

class TenMinuteControllerTest < ActionController::TestCase
  test "should get index" do
    get :show
    assert_response :success
  end

  test "should get bet" do
    get :bet
    assert_response :success
  end

end
