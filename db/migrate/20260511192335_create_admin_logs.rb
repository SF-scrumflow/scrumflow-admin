class CreateAdminLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :admin_logs do |t|
      t.string :admin_email
      t.string :action
      t.string :resource_type
      t.integer :resource_id
      t.jsonb :metadata

      t.timestamps
    end
  end
end
