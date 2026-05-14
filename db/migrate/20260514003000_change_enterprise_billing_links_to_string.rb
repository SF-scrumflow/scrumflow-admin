class ChangeEnterpriseBillingLinksToString < ActiveRecord::Migration[7.2]
  def up
    change_column :enterprise_billings, :enterprise_id, :string, using: "enterprise_id::text"
    change_column :billing_histories, :enterprise_id, :string, using: "enterprise_id::text"
  end

  def down
    change_column :enterprise_billings, :enterprise_id, :bigint, using: "NULLIF(enterprise_id, '')::bigint"
    change_column :billing_histories, :enterprise_id, :bigint, using: "NULLIF(enterprise_id, '')::bigint"
  end
end
