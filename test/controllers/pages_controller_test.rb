require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get how_to_sauna" do
    get pages_how_to_sauna_url
    assert_response :success
  end
end
