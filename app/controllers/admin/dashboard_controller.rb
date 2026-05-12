class Admin::DashboardController < Admin::BaseController
  def index
    @total_enterprises = Enterprise.limit(1).count
  end
end