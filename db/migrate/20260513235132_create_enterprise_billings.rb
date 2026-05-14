class CreateEnterpriseBillings < ActiveRecord::Migration[7.2]
  def change
    create_table :enterprise_billings do |t|
      t.references :enterprise, null: false, foreign_key: false # since enterprise is in another db
      t.references :plan, null: true, foreign_key: false
      t.decimal :charged_value, precision: 10, scale: 2, default: 0.0
      t.string :financial_status, default: 'em_dia' # em_dia, pendente, atrasado, isento, cancelado
      t.date :next_billing_date
      t.date :last_payment_date
      t.string :account_status, default: 'ativa' # ativa, inativa, suspensa
      t.text :internal_notes
      t.timestamps
    end
  end
end
