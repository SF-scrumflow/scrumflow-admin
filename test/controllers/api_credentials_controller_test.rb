require "test_helper"

class ApiCredentialsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_credential = api_credentials(:one)
  end

  test "should get index" do
    get api_credentials_url, as: :json
    assert_response :success
  end

  test "should create api_credential" do
    assert_difference("ApiCredential.count") do
      post api_credentials_url, params: { api_credential: { active: @api_credential.active, last_used_at: @api_credential.last_used_at, name: @api_credential.name, token: @api_credential.token } }, as: :json
    end

    assert_response :created
  end

  test "should show api_credential" do
    get api_credential_url(@api_credential), as: :json
    assert_response :success
  end

  test "should update api_credential" do
    patch api_credential_url(@api_credential), params: { api_credential: { active: @api_credential.active, last_used_at: @api_credential.last_used_at, name: @api_credential.name, token: @api_credential.token } }, as: :json
    assert_response :success
  end

  test "should destroy api_credential" do
    assert_difference("ApiCredential.count", -1) do
      delete api_credential_url(@api_credential), as: :json
    end

    assert_response :no_content
  end
end
