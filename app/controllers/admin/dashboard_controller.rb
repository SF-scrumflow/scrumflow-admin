class Admin::DashboardController < Admin::BaseController
  def index
    Rails.logger.info "ANTES"

    Enterprise.connection.execute("SELECT 1") 

    Rails.logger.info "DEPOIS"
  end
end