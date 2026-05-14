class EnterpriseBilling < ApplicationRecord
  belongs_to :enterprise, optional: true # since it's in another db
  belongs_to :plan, optional: true

  BILLING_CYCLES = %w[monthly annual yearly].freeze
  FINANCIAL_STATUSES = %w[em_dia pendente atrasado isento cancelado bloqueado].freeze
  ACCOUNT_STATUSES = %w[acessivel trial sem_acesso ativa bloqueada cancelada inativa suspensa].freeze

  validates :charged_value, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :financial_status, inclusion: { in: FINANCIAL_STATUSES }
  validates :account_status, inclusion: { in: ACCOUNT_STATUSES }
  validates :billing_cycle, inclusion: { in: BILLING_CYCLES }
  validates :tolerance_days, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :block_after_days, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def display_charged_value
    charged_value.present? ? "R$ #{'%.2f' % charged_value}" : "N/A"
  end

  def display_financial_status
    case financial_status
    when "em_dia" then "Em dia"
    when "pendente" then "Pendente"
    when "atrasado" then "Atrasado"
    when "isento" then "Isento"
    when "cancelado" then "Cancelado"
    when "bloqueado" then "Bloqueado"
    else "N/A"
    end
  end

  def display_account_status
    case account_status
    when "acessivel", "ativa" then "Acessível"
    when "trial" then "Trial"
    when "sem_acesso", "bloqueada", "cancelada", "inativa", "suspensa" then "Sem acesso"
    else "N/A"
    end
  end

  def next_billing_date_after_payment(payment_date)
    return unless payment_date.present?

    case billing_cycle
    when "annual", "yearly"
      payment_date.advance(years: 1)
    else
      payment_date.advance(months: 1)
    end
  end
end
