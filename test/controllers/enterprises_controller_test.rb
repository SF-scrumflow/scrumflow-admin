require "test_helper"

class EnterprisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @enterprise = enterprises(:one)
  end

  test "should get index" do
    get enterprises_url, as: :json
    assert_response :success
  end

  test "should create enterprise" do
    assert_difference("Enterprise.count") do
      post enterprises_url, params: { enterprise: { active: @enterprise.active, name: @enterprise.name, plan_id: @enterprise.plan_id, projects_count: @enterprise.projects_count, users_count: @enterprise.users_count } }, as: :json
    end

    assert_response :created
  end

  test "should show enterprise" do
    get enterprise_url(@enterprise), as: :json
    assert_response :success
  end

  test "should update enterprise" do
    patch enterprise_url(@enterprise), params: { enterprise: { active: @enterprise.active, name: @enterprise.name, plan_id: @enterprise.plan_id, projects_count: @enterprise.projects_count, users_count: @enterprise.users_count } }, as: :json
    assert_response :success
  end

  test "should destroy enterprise" do
    assert_difference("Enterprise.count", -1) do
      delete enterprise_url(@enterprise), as: :json
    end

    assert_response :no_content
  end
end
