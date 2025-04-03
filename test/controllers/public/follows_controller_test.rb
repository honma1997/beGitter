require "test_helper"

class Public::FollowsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_follows_create_url
    assert_response :success
  end

  test "should get destroy" do
    get public_follows_destroy_url
    assert_response :success
  end
end
