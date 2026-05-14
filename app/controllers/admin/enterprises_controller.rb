class Admin::EnterprisesController < Admin::BaseController
  before_action :set_enterprise, only: [ :show, :edit_billing, :update_billing, :register_payment, :update_register_payment ]

  def index
    @filter_options = enterprise_filter_options
    @sort_options = enterprise_sort_options
    @current_sort = permitted_sort
    @current_direction = permitted_direction

    enterprises = Enterprise.all.to_a
    preload_enterprise_associations(enterprises)

    enterprises = apply_enterprise_filters(enterprises)
    enterprises = sort_enterprises(enterprises)

    @enterprises = Kaminari.paginate_array(enterprises).page(params[:page]).per(25)
    @users_count_by_enterprise = association_counts_for(User, @enterprises)
    @projects_count_by_enterprise = association_counts_for(Project, @enterprises)
  end

  def show
    @subscriptions = @enterprise.subscriptions
    @users_count = @enterprise.users.count
    @projects_count = @enterprise.projects.count
    @billing_histories = @enterprise.billing_histories.order(created_at: :desc)
    @client_data = client_data_fields(@enterprise)
  end

  def edit_billing
    @billing = @enterprise.enterprise_billing || @enterprise.build_enterprise_billing
    @plans = Plan.all
  end

  def update_billing
    @billing = @enterprise.enterprise_billing || @enterprise.build_enterprise_billing
    previous_plan = @billing.plan
    previous_charged_value = @billing.charged_value
    previous_financial_status = @billing.financial_status
    previous_account_status = @billing.account_status
    previous_next_billing_date = @billing.next_billing_date

    if @billing.update(billing_params)
      plan_changed = @billing.saved_change_to_plan_id?
      @billing.association(:plan).reset

      update_enterprise_permissions(@enterprise, @billing.plan) if plan_changed

      BillingHistory.create!(
        enterprise_id: @enterprise.id,
        admin: current_admin,
        change_type: "manual",
        plan: @billing.plan,
        previous_plan: previous_plan,
        charged_value: @billing.charged_value,
        previous_charged_value: previous_charged_value,
        financial_status: @billing.financial_status,
        previous_financial_status: previous_financial_status,
        account_status: @billing.account_status,
        previous_account_status: previous_account_status,
        next_billing_date: @billing.next_billing_date,
        previous_next_billing_date: previous_next_billing_date,
        change_reason: params[:billing][:change_reason] || "Alteração manual de plano e cobrança",
        internal_notes: @billing.internal_notes
      )

      redirect_to admin_enterprise_path(@enterprise), notice: "Plano e cobrança atualizados com sucesso."
    else
      @plans = Plan.all
      render :edit_billing
    end
  end

  def register_payment
    @billing = @enterprise.enterprise_billing || @enterprise.build_enterprise_billing
  end

  def update_register_payment
    @billing = @enterprise.enterprise_billing || @enterprise.build_enterprise_billing
    previous_financial_status = @billing.financial_status
    previous_account_status = @billing.account_status
    previous_next_billing_date = @billing.next_billing_date

    payment_date = payment_params[:payment_date].presence && Date.parse(payment_params[:payment_date])
    payment_amount = payment_params[:payment_amount]
    payment_method = payment_params[:payment_method]

    @billing.financial_status = "em_dia"
    @billing.last_payment_date = payment_date
    @billing.next_billing_date = @billing.next_billing_date_after_payment(payment_date) if payment_date.present?
    @billing.account_status = "acessivel" if @billing.account_status.in?(%w[sem_acesso bloqueada])

    if @billing.save
      BillingHistory.create!(
        enterprise_id: @enterprise.id,
        admin: current_admin,
        change_type: "manual",
        plan: @billing.plan,
        previous_plan: @billing.plan,
        charged_value: @billing.charged_value,
        previous_charged_value: @billing.charged_value,
        financial_status: @billing.financial_status,
        previous_financial_status: previous_financial_status,
        account_status: @billing.account_status,
        previous_account_status: previous_account_status,
        next_billing_date: @billing.next_billing_date,
        previous_next_billing_date: previous_next_billing_date,
        payment_date: payment_date,
        payment_amount: payment_amount,
        payment_method: payment_method,
        change_reason: payment_params[:change_reason].presence || "Registro de pagamento manual",
        internal_notes: payment_params[:internal_notes]
      )

      redirect_to admin_enterprise_path(@enterprise), notice: "Pagamento registrado com sucesso."
    else
      render :register_payment
    end
  end

  private

  def set_enterprise
    @enterprise = Enterprise.find(params[:id])
  end

  def billing_params
    params.require(:billing).permit(
      :plan_id,
      :charged_value,
      :financial_status,
      :next_billing_date,
      :last_payment_date,
      :account_status,
      :billing_cycle,
      :tolerance_days,
      :block_after_days,
      :auto_block_enabled,
      :internal_notes
    )
  end

  def payment_params
    params.require(:billing).permit(
      :payment_date,
      :payment_amount,
      :payment_method,
      :internal_notes,
      :change_reason
    )
  end

  def update_enterprise_permissions(enterprise, plan)
    Rails.logger.info "Updating permissions for enterprise #{enterprise.id} to plan #{plan&.display_name}"
  end

  def preload_enterprise_associations(enterprises)
    return if enterprises.blank?

    ActiveRecord::Associations::Preloader.new(
      records: enterprises,
      associations: [ :plan, { enterprise_billing: :plan } ]
    ).call
  end

  def association_counts_for(model, enterprises)
    return {} unless model.column_names.include?("enterprise_id")

    enterprise_ids = enterprises.map(&:id).compact
    return {} if enterprise_ids.blank?

    model.where(enterprise_id: enterprise_ids).group(:enterprise_id).count
  end

  def apply_enterprise_filters(enterprises)
    enterprises.select do |enterprise|
      matches_search?(enterprise) &&
        matches_plan?(enterprise) &&
        matches_financial_status?(enterprise) &&
        matches_account_status?(enterprise) &&
        matches_next_billing?(enterprise) &&
        matches_charged_value?(enterprise) &&
        matches_created_at?(enterprise)
    end
  end

  def matches_search?(enterprise)
    search = params[:search].to_s.strip.downcase
    return true if search.blank?

    [
      enterprise.display_name,
      enterprise.attribute_value(:responsible),
      enterprise.attribute_value(:email)
    ].compact.any? { |value| value.to_s.downcase.include?(search) }
  end

  def matches_plan?(enterprise)
    case params[:plan_filter]
    when "free", "basic", "pro"
      normalize_filter_value(enterprise.current_plan_name).include?(params[:plan_filter])
    when "none"
      enterprise.current_plan.blank?
    else
      true
    end
  end

  def matches_financial_status?(enterprise)
    status = enterprise.financial_status

    case params[:financial_status]
    when "na"
      status.blank?
    when "em_dia", "pendente", "atrasado", "isento", "cancelado"
      status == params[:financial_status]
    else
      true
    end
  end

  def matches_account_status?(enterprise)
    status = enterprise.effective_account_status

    case params[:account_status]
    when "na"
      status.blank?
    when "acessivel", "trial", "sem_acesso"
      status == params[:account_status]
    else
      true
    end
  end

  def matches_next_billing?(enterprise)
    date = enterprise.next_billing_date

    case params[:next_billing]
    when "today"
      date == Date.current
    when "next_7_days"
      date.present? && date.between?(Date.current, 7.days.from_now.to_date)
    when "next_14_days"
      date.present? && date.between?(Date.current, 14.days.from_now.to_date)
    when "overdue"
      date.present? && date < Date.current
    when "none"
      date.blank?
    else
      true
    end
  end

  def matches_charged_value?(enterprise)
    value = enterprise.charged_value

    case params[:charged_value]
    when "zero"
      value.present? && value.to_d.zero?
    when "charged"
      value.present? && value.to_d.positive?
    when "missing"
      value.blank?
    else
      true
    end
  end

  def matches_created_at?(enterprise)
    created_at = enterprise_created_at(enterprise)&.to_date

    case params[:created_at_filter]
    when "today"
      created_at == Date.current
    when "last_7_days"
      created_at.present? && created_at >= 7.days.ago.to_date
    when "last_30_days"
      created_at.present? && created_at >= 30.days.ago.to_date
    when "this_month"
      created_at.present? && created_at.between?(Date.current.beginning_of_month, Date.current.end_of_month)
    when "last_month"
      last_month = Date.current.last_month
      created_at.present? && created_at.between?(last_month.beginning_of_month, last_month.end_of_month)
    else
      true
    end
  end

  def sort_enterprises(enterprises)
    enterprises.sort do |left, right|
      left_value = enterprise_sort_value(left, @current_sort)
      right_value = enterprise_sort_value(right, @current_sort)

      if left_value.blank? && right_value.blank?
        0
      elsif left_value.blank?
        1
      elsif right_value.blank?
        -1
      else
        comparison = left_value <=> right_value
        @current_direction == "desc" ? -comparison : comparison
      end
    end
  end

  def enterprise_sort_value(enterprise, sort)
    case sort
    when "name"
      enterprise.display_name.to_s.downcase
    when "plan"
      enterprise.current_plan_name.to_s.downcase
    when "charged_value"
      enterprise.charged_value
    when "financial_status"
      enterprise.display_financial_status.to_s.downcase
    when "account_status"
      enterprise.display_effective_account_status.to_s.downcase
    when "last_payment_date"
      enterprise.last_payment_date
    when "next_billing_date"
      enterprise.next_billing_date
    else
      enterprise_created_at(enterprise)
    end
  end

  def enterprise_created_at(enterprise)
    enterprise.attribute_value(:created_at)
  end

  def normalize_filter_value(value)
    I18n.transliterate(value.to_s).downcase
  end

  def client_data_fields(enterprise)
    [
      [ "ID da empresa", enterprise.id ],
      [ "Responsável", first_present_attribute(enterprise, :responsible, :responsible_name, :owner_name, :contact_name) ],
      [ "E-mail", first_present_attribute(enterprise, :email, :responsible_email, :owner_email, :contact_email) ],
      [ "Telefone", first_present_attribute(enterprise, :phone, :telephone, :responsible_phone, :contact_phone, :whatsapp) ],
      [ "Documento", first_present_attribute(enterprise, :document, :document_number, :cnpj, :cpf, :tax_id) ],
      [ "Domínio", first_present_attribute(enterprise, :domain, :slug, :subdomain) ],
      [ "Criada em", enterprise_created_at(enterprise)&.strftime("%d/%m/%Y %H:%M") ],
      [ "Atualizada em", enterprise.attribute_value(:updated_at)&.strftime("%d/%m/%Y %H:%M") ]
    ]
  end

  def first_present_attribute(record, *attributes)
    attributes.each do |attribute|
      value = record.attribute_value(attribute)
      return value if value.present?
    end

    nil
  end

  def permitted_sort
    enterprise_sort_options.map(&:last).include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def permitted_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def enterprise_filter_options
    {
      plans: [
        [ "Todos", "" ],
        [ "Free", "free" ],
        [ "Basic", "basic" ],
        [ "Pro", "pro" ],
        [ "Sem plano / N/A", "none" ]
      ],
      financial_statuses: [
        [ "Todos", "" ],
        [ "Em dia", "em_dia" ],
        [ "Pendente", "pendente" ],
        [ "Atrasado", "atrasado" ],
        [ "Isento", "isento" ],
        [ "Cancelado", "cancelado" ],
        [ "N/A", "na" ]
      ],
      account_statuses: [
        [ "Todos", "" ],
        [ "Acessível", "acessivel" ],
        [ "Trial", "trial" ],
        [ "Sem acesso", "sem_acesso" ]
      ],
      next_billing: [
        [ "Todas", "" ],
        [ "Vence hoje", "today" ],
        [ "Vence nos próximos 7 dias", "next_7_days" ],
        [ "Vence nos próximos 14 dias", "next_14_days" ],
        [ "Vencidas", "overdue" ],
        [ "Sem próxima cobrança", "none" ]
      ],
      charged_values: [
        [ "Todos", "" ],
        [ "Valor zerado", "zero" ],
        [ "Com valor cobrado", "charged" ],
        [ "Sem valor informado", "missing" ]
      ],
      created_at: [
        [ "Todas", "" ],
        [ "Criadas hoje", "today" ],
        [ "Criadas nos últimos 7 dias", "last_7_days" ],
        [ "Criadas nos últimos 30 dias", "last_30_days" ],
        [ "Criadas neste mês", "this_month" ],
        [ "Criadas no mês passado", "last_month" ]
      ]
    }
  end

  def enterprise_sort_options
    [
      [ "Nome da empresa", "name" ],
      [ "Plano", "plan" ],
      [ "Valor cobrado", "charged_value" ],
      [ "Status financeiro", "financial_status" ],
      [ "Status da conta", "account_status" ],
      [ "Último pagamento", "last_payment_date" ],
      [ "Próxima cobrança", "next_billing_date" ],
      [ "Data de criação", "created_at" ]
    ]
  end
end
