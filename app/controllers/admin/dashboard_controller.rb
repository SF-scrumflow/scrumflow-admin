class Admin::DashboardController < Admin::BaseController
  def index
    @metrics = ::DashboardMetrics.new(params)

    @total_enterprises = Enterprise.count
    @active_enterprises = Enterprise.column_names.include?("active") ? Enterprise.where(active: true).count : nil

    @total_subscriptions = Subscription.count
    @active_subscriptions = Subscription.column_names.include?("status") ? Subscription.where(status: "active").count : nil

    @total_users = User.count
    @total_projects = Project.count

    @recent_enterprises = Enterprise.order(created_at: :desc).limit(5)
    @recent_logs = AdminLog.order(created_at: :desc).limit(10)

    @plans = Plan.all
    @billing_cycles = EnterpriseBilling::BILLING_CYCLES
    @account_statuses = [
      [ "Acessível", "acessivel" ],
      [ "Trial", "trial" ],
      [ "Sem acesso", "sem_acesso" ]
    ]
  end
end
