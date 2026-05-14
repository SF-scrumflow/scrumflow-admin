class AddMissingBillingAutomationColumns < ActiveRecord::Migration[7.2]
  def up
    add_column :enterprise_billings, :billing_cycle, :string, default: 'monthly', null: false unless column_exists?(:enterprise_billings, :billing_cycle)
    add_column :enterprise_billings, :tolerance_days, :integer, default: 14, null: false unless column_exists?(:enterprise_billings, :tolerance_days)
    add_column :enterprise_billings, :block_after_days, :integer, default: 7, null: false unless column_exists?(:enterprise_billings, :block_after_days)
    add_column :enterprise_billings, :auto_block_enabled, :boolean, default: false, null: false unless column_exists?(:enterprise_billings, :auto_block_enabled)

    add_column :billing_histories, :change_type, :string, default: 'manual', null: false unless column_exists?(:billing_histories, :change_type)
    add_column :billing_histories, :account_status, :string unless column_exists?(:billing_histories, :account_status)
    add_column :billing_histories, :previous_account_status, :string unless column_exists?(:billing_histories, :previous_account_status)
    add_column :billing_histories, :payment_date, :date unless column_exists?(:billing_histories, :payment_date)
    add_column :billing_histories, :payment_amount, :decimal, precision: 10, scale: 2 unless column_exists?(:billing_histories, :payment_amount)
    add_column :billing_histories, :payment_method, :string unless column_exists?(:billing_histories, :payment_method)
    change_column_null :billing_histories, :admin_id, true if column_exists?(:billing_histories, :admin_id)
  end

  def down
    remove_column :enterprise_billings, :billing_cycle if column_exists?(:enterprise_billings, :billing_cycle)
    remove_column :enterprise_billings, :tolerance_days if column_exists?(:enterprise_billings, :tolerance_days)
    remove_column :enterprise_billings, :block_after_days if column_exists?(:enterprise_billings, :block_after_days)
    remove_column :enterprise_billings, :auto_block_enabled if column_exists?(:enterprise_billings, :auto_block_enabled)

    remove_column :billing_histories, :change_type if column_exists?(:billing_histories, :change_type)
    remove_column :billing_histories, :account_status if column_exists?(:billing_histories, :account_status)
    remove_column :billing_histories, :previous_account_status if column_exists?(:billing_histories, :previous_account_status)
    remove_column :billing_histories, :payment_date if column_exists?(:billing_histories, :payment_date)
    remove_column :billing_histories, :payment_amount if column_exists?(:billing_histories, :payment_amount)
    remove_column :billing_histories, :payment_method if column_exists?(:billing_histories, :payment_method)
  end
end
