class Admin::ProjectsController < Admin::BaseController
  before_action :set_project, only: [:show]

  def index
    @projects = Project.all
    @projects = @projects.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present? && Project.column_names.include?("name")
    @projects = @projects.order(created_at: :desc) if Project.column_names.include?("created_at")
    @projects = @projects.page(params[:page]).per(25)
  end

  def show
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
