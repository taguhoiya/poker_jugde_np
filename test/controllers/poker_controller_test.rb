require "test_helper"

class PokerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get poker_index_url
    assert_response :success
  end

  test "should get create" do
    get poker_create_url
    assert_response :success
  end
end
