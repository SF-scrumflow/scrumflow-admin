require "test_helper"

class AuditEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @audit_event = audit_events(:one)
  end

  test "should get index" do
    get audit_events_url, as: :json
    assert_response :success
  end

  test "should create audit_event" do
    assert_difference("AuditEvent.count") do
      post audit_events_url, params: { audit_event: { admin_email: @audit_event.admin_email, event_type: @audit_event.event_type, payload: @audit_event.payload, resource_id: @audit_event.resource_id, resource_type: @audit_event.resource_type } }, as: :json
    end

    assert_response :created
  end

  test "should show audit_event" do
    get audit_event_url(@audit_event), as: :json
    assert_response :success
  end

  test "should update audit_event" do
    patch audit_event_url(@audit_event), params: { audit_event: { admin_email: @audit_event.admin_email, event_type: @audit_event.event_type, payload: @audit_event.payload, resource_id: @audit_event.resource_id, resource_type: @audit_event.resource_type } }, as: :json
    assert_response :success
  end

  test "should destroy audit_event" do
    assert_difference("AuditEvent.count", -1) do
      delete audit_event_url(@audit_event), as: :json
    end

    assert_response :no_content
  end
end
