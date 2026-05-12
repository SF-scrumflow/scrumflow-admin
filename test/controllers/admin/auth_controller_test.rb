require "test_helper"

class Admin::AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get me" do
    get admin_auth_me_url
    assert_response :success
  end
end
