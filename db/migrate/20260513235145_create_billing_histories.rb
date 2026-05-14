class CreateBillingHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :billing_histories do |t|
      t.references :enterprise, null: false, foreign_key: false
      t.references :admin, null: false, foreign_key: true
      t.references :plan, null: true, foreign_key: false
      t.references :previous_plan, null: true, foreign_key: false
      t.decimal :charged_value, precision: 10, scale: 2
      t.decimal :previous_charged_value, precision: 10, scale: 2
      t.string :financial_status
      t.string :previous_financial_status
      t.date :next_billing_date
      t.date :previous_next_billing_date
      t.string :change_reason, null: false
      t.text :internal_notes
      t.timestamps
    end
  end
end
