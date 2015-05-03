require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  def setup
    @user = users(:one)
    @user.authenticate(default_password)
  end
  test "should get new" do
    get :new
    assert_response :success
  end

end
