require "test_helper"

class DocumentationControllerTest < ActionDispatch::IntegrationTest
  test "should get docs_page" do
    get documentation_docs_page_url
    assert_response :success
  end

  test "should get docs_page_updated" do
    get documentation_docs_page_updated_url
    assert_response :success
  end
end
