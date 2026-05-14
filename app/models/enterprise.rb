class Enterprise < ScrumflowRecord
  belongs_to :plan, optional: true
  has_many :subscriptions
  has_many :users
  has_many :projects

  # Association to local billing info
  has_one :enterprise_billing, foreign_key: :enterprise_id, primary_key: :id
  has_many :billing_histories, foreign_key: :enterprise_id, primary_key: :id

  delegate :charged_value, :financial_status, :next_billing_date, :last_payment_date, :account_status, :internal_notes,
           :billing_cycle, :tolerance_days, :block_after_days, :auto_block_enabled,
           :display_charged_value, :display_financial_status, :display_account_status,
           to: :enterprise_billing, allow_nil: true

  def display_name
    attribute_value(:name) || "Empresa ##{id}"
  end

  def active_status
    return "Inativa" if deleted?
    return "Ativa" if has_attribute?(:deleted_at)
    return nil unless has_attribute?(:active)

    active? ? "Ativa" : "Inativa"
  end

  def active_badge
    active_status == "Ativa" ? "badge-success" : "badge-danger"
  end

  def effective_account_status
    simplified_account_status(account_status.presence || active_account_status)
  end

  def display_effective_account_status
    case effective_account_status
    when "acessivel" then "Acessível"
    when "trial" then "Trial"
    when "sem_acesso" then "Sem acesso"
    else "N/A"
    end
  end

  def effective_account_status_badge
    case effective_account_status
    when "acessivel" then "badge-success"
    when "trial" then "badge-info"
    when "sem_acesso" then "badge-danger"
    else "badge-info"
    end
  end

  def attribute_value(attribute)
    return unless has_attribute?(attribute)

    value = public_send(attribute)
    value if value.present?
  end

  def current_plan
    enterprise_billing&.plan || plan
  end

  def current_plan_name
    current_plan&.display_name || "N/A"
  end

  private

  def active_account_status
    return "inativa" if deleted?
    return "ativa" if has_attribute?(:deleted_at)
    return unless has_attribute?(:active)

    active? ? "ativa" : "inativa"
  end

  def deleted?
    has_attribute?(:deleted_at) && deleted_at.present?
  end

  def simplified_account_status(status)
    case status
    when "acessivel", "ativa"
      "acessivel"
    when "trial"
      "trial"
    when "sem_acesso", "bloqueada", "cancelada", "inativa", "suspensa"
      "sem_acesso"
    else
      nil
    end
  end
end
