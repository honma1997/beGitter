require "test_helper"

class Public::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_users_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_users_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_users_update_url
    assert_response :success
  end

  test "should get mypage" do
    get public_users_mypage_url
    assert_response :success
  end

  test "should get index" do
    get public_users_index_url
    assert_response :success
  end

  test "should get search" do
    get public_users_search_url
    assert_response :success
  end

  test "should get destroy" do
    get public_users_destroy_url
    assert_response :success
  end
end
