class Admin::AdminLogsController < Admin::BaseController
  def index
    @admin_logs = AdminLog.all
    @admin_logs = @admin_logs.where("action ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @admin_logs = @admin_logs.order(created_at: :desc).page(params[:page]).per(50)
  end
end
