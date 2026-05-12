class Enterprise < ScrumflowRecord
  belongs_to :plan, optional: true
  has_many :subscriptions
  has_many :users
  has_many :projects

  def display_name
    attribute_value(:name) || "Empresa ##{id}"
  end

  def active_status
    return nil unless has_attribute?(:active)

    active? ? "Ativa" : "Inativa"
  end

  def active_badge
    active? ? "badge-success" : "badge-danger"
  end

  def attribute_value(attribute)
    return unless has_attribute?(attribute)

    value = public_send(attribute)
    value if value.present?
  end
end
