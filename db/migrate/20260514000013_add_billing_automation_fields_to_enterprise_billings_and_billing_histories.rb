class AddBillingAutomationFieldsToEnterpriseBillingsAndBillingHistories < ActiveRecord::Migration[7.2]
  def change
    add_column :enterprise_billings, :billing_cycle, :string, default: 'monthly', null: false
    add_column :enterprise_billings, :tolerance_days, :integer, default: 14, null: false
    add_column :enterprise_billings, :block_after_days, :integer, default: 7, null: false
    add_column :enterprise_billings, :auto_block_enabled, :boolean, default: false, null: false

    add_column :billing_histories, :change_type, :string, default: 'manual', null: false
    add_column :billing_histories, :account_status, :string
    add_column :billing_histories, :previous_account_status, :string
    add_column :billing_histories, :payment_date, :date
    add_column :billing_histories, :payment_amount, :decimal, precision: 10, scale: 2
    add_column :billing_histories, :payment_method, :string
    change_column_null :billing_histories, :admin_id, true
  end
end
