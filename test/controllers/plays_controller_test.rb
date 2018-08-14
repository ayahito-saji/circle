require 'test_helper'

class PlaysControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get plays_show_url
    assert_response :success
  end

end
