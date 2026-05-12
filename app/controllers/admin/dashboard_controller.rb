class Admin::DashboardController < Admin::BaseController
  def index
    @total_enterprises = Enterprise.connection.execute("SELECT 1")
  end
end