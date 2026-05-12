require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subscription = subscriptions(:one)
  end

  test "should get index" do
    get subscriptions_url, as: :json
    assert_response :success
  end

  test "should create subscription" do
    assert_difference("Subscription.count") do
      post subscriptions_url, params: { subscription: { billing_period: @subscription.billing_period, ends_at: @subscription.ends_at, enterprise_id: @subscription.enterprise_id, plan_id: @subscription.plan_id, starts_at: @subscription.starts_at, status: @subscription.status } }, as: :json
    end

    assert_response :created
  end

  test "should show subscription" do
    get subscription_url(@subscription), as: :json
    assert_response :success
  end

  test "should update subscription" do
    patch subscription_url(@subscription), params: { subscription: { billing_period: @subscription.billing_period, ends_at: @subscription.ends_at, enterprise_id: @subscription.enterprise_id, plan_id: @subscription.plan_id, starts_at: @subscription.starts_at, status: @subscription.status } }, as: :json
    assert_response :success
  end

  test "should destroy subscription" do
    assert_difference("Subscription.count", -1) do
      delete subscription_url(@subscription), as: :json
    end

    assert_response :no_content
  end
end
