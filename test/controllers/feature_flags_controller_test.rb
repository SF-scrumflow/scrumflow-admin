require "test_helper"

class FeatureFlagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @feature_flag = feature_flags(:one)
  end

  test "should get index" do
    get feature_flags_url, as: :json
    assert_response :success
  end

  test "should create feature_flag" do
    assert_difference("FeatureFlag.count") do
      post feature_flags_url, params: { feature_flag: { description: @feature_flag.description, enabled: @feature_flag.enabled, key: @feature_flag.key, name: @feature_flag.name } }, as: :json
    end

    assert_response :created
  end

  test "should show feature_flag" do
    get feature_flag_url(@feature_flag), as: :json
    assert_response :success
  end

  test "should update feature_flag" do
    patch feature_flag_url(@feature_flag), params: { feature_flag: { description: @feature_flag.description, enabled: @feature_flag.enabled, key: @feature_flag.key, name: @feature_flag.name } }, as: :json
    assert_response :success
  end

  test "should destroy feature_flag" do
    assert_difference("FeatureFlag.count", -1) do
      delete feature_flag_url(@feature_flag), as: :json
    end

    assert_response :no_content
  end
end
