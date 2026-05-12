class Subscription < ScrumflowRecord
  belongs_to :enterprise, optional: true
  belongs_to :plan, optional: true

  def attribute_value(attribute)
    return unless has_attribute?(attribute)

    value = public_send(attribute)
    value if value.present?
  end

  def display_status
    attribute_value(:status) || "N/A"
  end

  def display_billing_period
    case attribute_value(:billing_period)
    when "monthly"
      "Mensal"
    when "annual", "yearly"
      "Anual"
    else
      attribute_value(:billing_period) || "N/A"
    end
  end
end
