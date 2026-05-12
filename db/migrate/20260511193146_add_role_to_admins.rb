class AddRoleToAdmins < ActiveRecord::Migration[7.2]
  def change
    add_column :admins, :role, :string
  end
end
