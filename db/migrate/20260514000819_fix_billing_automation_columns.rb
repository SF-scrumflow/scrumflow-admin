class FixBillingAutomationColumns < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:enterprise_billings, :billing_cycle)
      add_column :enterprise_billings, :billing_cycle, :string, default: 'monthly', null: false
    end

    unless column_exists?(:enterprise_billings, :tolerance_days)
      add_column :enterprise_billings, :tolerance_days, :integer, default: 14, null: false
    end

    unless column_exists?(:enterprise_billings, :block_after_days)
      add_column :enterprise_billings, :block_after_days, :integer, default: 7, null: false
    end

    unless column_exists?(:enterprise_billings, :auto_block_enabled)
      add_column :enterprise_billings, :auto_block_enabled, :boolean, default: false, null: false
    end

    unless column_exists?(:billing_histories, :change_type)
      add_column :billing_histories, :change_type, :string, default: 'manual', null: false
    end

    unless column_exists?(:billing_histories, :account_status)
      add_column :billing_histories, :account_status, :string
    end

    unless column_exists?(:billing_histories, :previous_account_status)
      add_column :billing_histories, :previous_account_status, :string
    end

    unless column_exists?(:billing_histories, :payment_date)
      add_column :billing_histories, :payment_date, :date
    end

    unless column_exists?(:billing_histories, :payment_amount)
      add_column :billing_histories, :payment_amount, :decimal, precision: 10, scale: 2
    end

    unless column_exists?(:billing_histories, :payment_method)
      add_column :billing_histories, :payment_method, :string
    end

    change_column_null :billing_histories, :admin_id, true, true
  end
end
