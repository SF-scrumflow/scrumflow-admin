class Admin::DashboardController < Admin::BaseController
  def index
    @total_enterprises = Enterprise.count
    @active_enterprises = Enterprise.column_names.include?("active") ? Enterprise.where(active: true).count : nil

    @total_subscriptions = Subscription.count
    @active_subscriptions = Subscription.column_names.include?("status") ? Subscription.where(status: 'active').count : nil
    @total_users = User.count
    @total_projects = Project.count

    @recent_enterprises = Enterprise.all
    @recent_enterprises = @recent_enterprises.order(created_at: :desc) if Enterprise.column_names.include?("created_at")
    @recent_enterprises = @recent_enterprises.limit(5)
    @recent_logs = AdminLog.order(created_at: :desc).limit(10)
  end
end
