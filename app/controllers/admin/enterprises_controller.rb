class Admin::EnterprisesController < Admin::BaseController
    before_action :set_enterprise, only: [:show]

    def index
      @enterprises = Enterprise.all
      @enterprises = @enterprises.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present? && Enterprise.column_names.include?("name")
      @enterprises = @enterprises.page(params[:page]).per(25)
    end

    def show
      @subscriptions = @enterprise.subscriptions
      @users_count = @enterprise.users.count
      @projects_count = @enterprise.projects.count
    end

    private

  def set_enterprise
    @enterprise = Enterprise.find(params[:id])
  end
end
