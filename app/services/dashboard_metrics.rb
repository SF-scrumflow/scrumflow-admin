class DashboardMetrics
  attr_reader :start_date, :end_date, :billing_cycle, :plan_id, :account_status

  DEFAULT_RANGE_DAYS = 30

  def initialize(params = {})
    @start_date = parse_date(params[:start_date]) || DEFAULT_RANGE_DAYS.days.ago.to_date
    @end_date = parse_date(params[:end_date]) || Date.current
    @billing_cycle = params[:billing_cycle].presence
    @plan_id = params[:plan_id].presence
    @account_status = params[:account_status].presence
  end

  def current_range
    start_date.beginning_of_day..end_date.end_of_day
  end

  def current_date_range
    start_date..end_date
  end

  def parse_date(value)
    return unless value.present?

    Date.parse(value.to_s)
  rescue ArgumentError
    nil
  end

  def billing_scope
    scope = EnterpriseBilling.all
    scope = scope.where(billing_cycle: billing_cycle) if billing_cycle
    scope = scope.where(plan_id: plan_id) if plan_id
    scope = scope.where(account_status: account_status_values(account_status)) if account_status
    scope
  end

  def history_scope
    scope = BillingHistory.all
    scope = scope.where(plan_id: plan_id) if plan_id
    scope = scope.where(created_at: current_range)
    scope
  end

  def active_customers_count
    billing_scope.where(account_status: account_status_values("acessivel")).count
  end

  def trial_customers_count
    billing_scope.where(account_status: "trial").count
  end

  def churned_customers_count
    billing_scope.where(account_status: account_status_values("sem_acesso")).count
  end

  def delinquent_customers_count
    billing_scope.where(financial_status: %w[pendente atrasado bloqueado]).count
  end

  def delinquent_revenue
    billing_scope.where(financial_status: %w[pendente atrasado bloqueado]).sum(:charged_value).to_f
  end

  def monthly_recurring_revenue
    billing_scope.sum(Arel.sql("CASE WHEN billing_cycle IN ('annual','yearly') THEN COALESCE(charged_value, 0) / 12.0 ELSE COALESCE(charged_value, 0) END")).to_f
  end

  def annual_recurring_revenue
    billing_scope.sum(Arel.sql("CASE WHEN billing_cycle = 'monthly' THEN COALESCE(charged_value, 0) * 12.0 ELSE COALESCE(charged_value, 0) END")).to_f
  end

  def average_revenue_per_user
    return 0.0 if active_customers_count.zero?

    monthly_recurring_revenue / active_customers_count
  end

  def customer_acquisition_count
    Enterprise.where(created_at: current_range).count
  end

  def customer_acquisition_rate
    total = Enterprise.count
    return 0.0 if total.zero?

    customer_acquisition_count.to_f / total * 100
  end

  def churn_count
    BillingHistory.where(account_status: account_status_values("sem_acesso"), created_at: current_range).distinct.count(:enterprise_id)
  end

  def churn_rate
    return 0.0 if active_customers_count.zero?

    churn_count.to_f / active_customers_count * 100
  end

  def expansion_revenue
    BillingHistory.where(created_at: current_range)
                  .where("charged_value > previous_charged_value")
                  .sum("COALESCE(charged_value, 0) - COALESCE(previous_charged_value, 0)").to_f
  end

  def churned_revenue
    BillingHistory.where(account_status: account_status_values("sem_acesso"), created_at: current_range)
                  .sum("COALESCE(previous_charged_value, charged_value, 0)").to_f
  end

  def net_revenue_retention
    return 100.0 if monthly_recurring_revenue.zero?

    retention = monthly_recurring_revenue - churned_revenue + expansion_revenue
    [(retention / monthly_recurring_revenue * 100).round(2), 0].max
  end

  def recent_subscription_changes
    history_scope.order(created_at: :desc).limit(8)
  end

  def recent_payment_activity
    BillingHistory.where(payment_date: current_date_range)
                  .where.not(payment_amount: nil)
                  .order(payment_date: :desc)
                  .limit(8)
  end

  def actual_revenue
    BillingHistory.where(payment_date: current_date_range).sum(:payment_amount).to_f
  end

  def planned_revenue_by_cycle
    billing_scope.group(:billing_cycle).sum(:charged_value)
  end

  def collected_revenue_by_cycle
    BillingHistory.where(payment_date: current_date_range)
                  .joins("INNER JOIN enterprise_billings ON billing_histories.enterprise_id = enterprise_billings.enterprise_id")
                  .group("enterprise_billings.billing_cycle")
                  .sum(:payment_amount)
  end

  def top_customers(limit = 10)
    billing_scope.order(charged_value: :desc).limit(limit)
  end

  def billing_records_count
    EnterpriseBilling.count
  end

  def history_records_count
    BillingHistory.count
  end

  def billing_data_present?
    billing_records_count.positive? || history_records_count.positive?
  end

  def subscription_status_counts
    return {} unless Subscription.column_names.include?("status")

    Subscription.group(:status).count
  end

  def revenue_by_cycle_data
    billing_scope.group(:billing_cycle).sum(:charged_value)
  end

  def total_projects_count
    Project.count
  end

  def active_projects_count
    return unless Project.column_names.include?("active")

    Project.where(active: true).count
  end

  def projects_created_count
    return unless Project.column_names.include?("created_at")

    Project.where(created_at: current_range).count
  end

  def average_projects_per_enterprise
    average_per_enterprise(total_projects_count)
  end

  def average_projects_per_active_customer
    average_per_enterprise(total_projects_count, active_customers_count)
  end

  def top_enterprises_by_projects(limit = 5)
    top_enterprises_by_association(Project, limit)
  end

  def total_users_count
    User.count
  end

  def active_users_count
    return unless User.column_names.include?("active")

    User.where(active: true).count
  end

  def users_created_count
    return unless User.column_names.include?("created_at")

    User.where(created_at: current_range).count
  end

  def average_users_per_enterprise
    average_per_enterprise(total_users_count)
  end

  def average_users_per_active_customer
    average_per_enterprise(total_users_count, active_customers_count)
  end

  def average_users_per_project
    return 0.0 if total_projects_count.zero?

    total_users_count.to_f / total_projects_count
  end

  def top_enterprises_by_users(limit = 5)
    top_enterprises_by_association(User, limit)
  end

  private

  def average_per_enterprise(total, enterprise_count = Enterprise.count)
    return 0.0 if enterprise_count.to_i.zero?

    total.to_f / enterprise_count
  end

  def top_enterprises_by_association(model, limit)
    return [] unless model.column_names.include?("enterprise_id")

    counts = model.where.not(enterprise_id: nil)
                  .group(:enterprise_id)
                  .count
                  .sort_by { |_enterprise_id, count| -count }
                  .first(limit)

    enterprise_ids = counts.map(&:first)
    enterprises_by_id = Enterprise.where(id: enterprise_ids).index_by(&:id)

    counts.map do |enterprise_id, count|
      {
        enterprise: enterprises_by_id[enterprise_id],
        enterprise_id: enterprise_id,
        count: count
      }
    end
  end

  def account_status_values(status)
    case status
    when "acessivel"
      %w[acessivel ativa]
    when "sem_acesso"
      %w[sem_acesso bloqueada cancelada inativa suspensa]
    else
      [ status ]
    end
  end
end
