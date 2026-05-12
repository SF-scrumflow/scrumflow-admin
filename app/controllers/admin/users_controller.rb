class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show]

  def index
    @users = User.all
    @users = @users.where("email ILIKE ?", "%#{params[:search]}%") if params[:search].present? && User.column_names.include?("email")
    @users = @users.order(created_at: :desc) if User.column_names.include?("created_at")
    @users = @users.page(params[:page]).per(25)
  end

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
