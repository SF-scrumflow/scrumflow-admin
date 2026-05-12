class Admin::AuthController < Admin::BaseController
  def me
    render json: {
      id: current_admin.id,
      email: current_admin.email,
      role: current_admin.role
    }
  end
end