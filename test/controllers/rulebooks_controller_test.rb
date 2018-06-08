require 'test_helper'

class RulebooksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get rulebooks_new_url
    assert_response :success
  end

  test "should get edit" do
    get rulebooks_edit_url
    assert_response :success
  end

end
