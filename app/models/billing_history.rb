class BillingHistory < ApplicationRecord
  belongs_to :enterprise, optional: true
  belongs_to :admin, optional: true
  belongs_to :plan, optional: true
  belongs_to :previous_plan, class_name: "Plan", optional: true

  VALID_CHANGE_TYPES = %w[manual automatica].freeze

  validates :change_reason, presence: true
  validates :change_type, inclusion: { in: VALID_CHANGE_TYPES }

  def display_charged_value
    charged_value.present? ? "R$ #{'%.2f' % charged_value}" : "N/A"
  end

  def display_previous_charged_value
    previous_charged_value.present? ? "R$ #{'%.2f' % previous_charged_value}" : "N/A"
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

  def display_previous_financial_status
    case previous_financial_status
    when "em_dia" then "Em dia"
    when "pendente" then "Pendente"
    when "atrasado" then "Atrasado"
    when "isento" then "Isento"
    when "cancelado" then "Cancelado"
    when "bloqueado" then "Bloqueado"
    else "N/A"
    end
  end

  def display_status_label(status)
    case status
    when "acessivel", "ativa" then "Acessível"
    when "trial" then "Trial"
    when "sem_acesso", "bloqueada", "cancelada", "inativa", "suspensa" then "Sem acesso"
    else "N/A"
    end
  end

  def display_previous_account_status
    display_status_label(previous_account_status)
  end

  def display_account_status
    display_status_label(account_status)
  end
end
