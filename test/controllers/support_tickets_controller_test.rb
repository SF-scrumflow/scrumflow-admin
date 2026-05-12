require "test_helper"

class SupportTicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @support_ticket = support_tickets(:one)
  end

  test "should get index" do
    get support_tickets_url, as: :json
    assert_response :success
  end

  test "should create support_ticket" do
    assert_difference("SupportTicket.count") do
      post support_tickets_url, params: { support_ticket: { assigned_to: @support_ticket.assigned_to, enterprise_id: @support_ticket.enterprise_id, priority: @support_ticket.priority, status: @support_ticket.status, subject: @support_ticket.subject } }, as: :json
    end

    assert_response :created
  end

  test "should show support_ticket" do
    get support_ticket_url(@support_ticket), as: :json
    assert_response :success
  end

  test "should update support_ticket" do
    patch support_ticket_url(@support_ticket), params: { support_ticket: { assigned_to: @support_ticket.assigned_to, enterprise_id: @support_ticket.enterprise_id, priority: @support_ticket.priority, status: @support_ticket.status, subject: @support_ticket.subject } }, as: :json
    assert_response :success
  end

  test "should destroy support_ticket" do
    assert_difference("SupportTicket.count", -1) do
      delete support_ticket_url(@support_ticket), as: :json
    end

    assert_response :no_content
  end
end
