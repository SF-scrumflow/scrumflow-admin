class BillingStatusUpdater
  DEFAULT_TOLERANCE_DAYS = 14

  def self.run!(reference_date = Date.current)
    new(reference_date).run!
  end

  def initialize(reference_date)
    @reference_date = reference_date
  end

  def run!
    EnterpriseBilling.includes(:enterprise, :plan).find_each do |billing|
      update_billing_status(billing)
    end
  end

  private

  attr_reader :reference_date

  def update_billing_status(billing)
    return if billing.account_status == "sem_acesso"
    return if billing.financial_status == "isento" && billing.charged_value.to_f.positive?

    new_financial_status = calculate_financial_status(billing)
    return if new_financial_status.blank? || new_financial_status == billing.financial_status

    previous_financial_status = billing.financial_status
    previous_account_status = billing.account_status

    billing.financial_status = new_financial_status

    if billing.auto_block_enabled && blocked_due?(billing)
      billing.account_status = "sem_acesso"
    end

    if billing.changed?
      billing.save!
      BillingHistory.create!(
        enterprise_id: billing.enterprise_id,
        admin: nil,
        change_type: "automatica",
        plan: billing.plan,
        previous_plan: billing.plan,
        charged_value: billing.charged_value,
        previous_charged_value: billing.charged_value,
        financial_status: billing.financial_status,
        previous_financial_status: previous_financial_status,
        account_status: billing.account_status,
        previous_account_status: previous_account_status,
        next_billing_date: billing.next_billing_date,
        previous_next_billing_date: billing.next_billing_date,
        change_reason: "Atualização automática de status financeiro",
        internal_notes: "Rotina diária de cobrança automática"
      )
    end
  end

  def calculate_financial_status(billing)
    return "isento" if billing.charged_value.to_f.zero?
    return if billing.next_billing_date.blank?

    tolerance_days = billing.tolerance_days || DEFAULT_TOLERANCE_DAYS
    due_date = billing.next_billing_date

    return "em_dia" if reference_date < due_date
    return "pendente" if reference_date <= due_date + tolerance_days.days

    "atrasado"
  end

  def blocked_due?(billing)
    return false unless billing.auto_block_enabled
    return false if billing.next_billing_date.blank?

    block_after_days = billing.block_after_days || 7
    reference_date > billing.next_billing_date + block_after_days.days
  end
end
