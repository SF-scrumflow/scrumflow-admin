require "test_helper"

class SystemSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_setting = system_settings(:one)
  end

  test "should get index" do
    get system_settings_url, as: :json
    assert_response :success
  end

  test "should create system_setting" do
    assert_difference("SystemSetting.count") do
      post system_settings_url, params: { system_setting: { key: @system_setting.key, value: @system_setting.value } }, as: :json
    end

    assert_response :created
  end

  test "should show system_setting" do
    get system_setting_url(@system_setting), as: :json
    assert_response :success
  end

  test "should update system_setting" do
    patch system_setting_url(@system_setting), params: { system_setting: { key: @system_setting.key, value: @system_setting.value } }, as: :json
    assert_response :success
  end

  test "should destroy system_setting" do
    assert_difference("SystemSetting.count", -1) do
      delete system_setting_url(@system_setting), as: :json
    end

    assert_response :no_content
  end
end
