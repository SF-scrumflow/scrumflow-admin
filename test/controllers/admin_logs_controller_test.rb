require "test_helper"

class AdminLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_log = admin_logs(:one)
  end

  test "should get index" do
    get admin_logs_url, as: :json
    assert_response :success
  end

  test "should create admin_log" do
    assert_difference("AdminLog.count") do
      post admin_logs_url, params: { admin_log: { action: @admin_log.action, admin_email: @admin_log.admin_email, metadata: @admin_log.metadata, resource_id: @admin_log.resource_id, resource_type: @admin_log.resource_type } }, as: :json
    end

    assert_response :created
  end

  test "should show admin_log" do
    get admin_log_url(@admin_log), as: :json
    assert_response :success
  end

  test "should update admin_log" do
    patch admin_log_url(@admin_log), params: { admin_log: { action: @admin_log.action, admin_email: @admin_log.admin_email, metadata: @admin_log.metadata, resource_id: @admin_log.resource_id, resource_type: @admin_log.resource_type } }, as: :json
    assert_response :success
  end

  test "should destroy admin_log" do
    assert_difference("AdminLog.count", -1) do
      delete admin_log_url(@admin_log), as: :json
    end

    assert_response :no_content
  end
end
