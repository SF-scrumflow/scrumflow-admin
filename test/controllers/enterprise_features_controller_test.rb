require "test_helper"

class EnterpriseFeaturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @enterprise_feature = enterprise_features(:one)
  end

  test "should get index" do
    get enterprise_features_url, as: :json
    assert_response :success
  end

  test "should create enterprise_feature" do
    assert_difference("EnterpriseFeature.count") do
      post enterprise_features_url, params: { enterprise_feature: { enabled: @enterprise_feature.enabled, enterprise_id: @enterprise_feature.enterprise_id, feature_flag_id: @enterprise_feature.feature_flag_id } }, as: :json
    end

    assert_response :created
  end

  test "should show enterprise_feature" do
    get enterprise_feature_url(@enterprise_feature), as: :json
    assert_response :success
  end

  test "should update enterprise_feature" do
    patch enterprise_feature_url(@enterprise_feature), params: { enterprise_feature: { enabled: @enterprise_feature.enabled, enterprise_id: @enterprise_feature.enterprise_id, feature_flag_id: @enterprise_feature.feature_flag_id } }, as: :json
    assert_response :success
  end

  test "should destroy enterprise_feature" do
    assert_difference("EnterpriseFeature.count", -1) do
      delete enterprise_feature_url(@enterprise_feature), as: :json
    end

    assert_response :no_content
  end
end
