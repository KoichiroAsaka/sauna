require "test_helper"

class SaunasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get saunas_index_url
    assert_response :success
  end
end
