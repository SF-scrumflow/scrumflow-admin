class User < ScrumflowRecord
  belongs_to :enterprise, optional: true

  def display_name
    attribute_value(:name) || attribute_value(:full_name) || attribute_value(:email) || "Usuário ##{id}"
  end

  def display_email
    attribute_value(:email) || "N/A"
  end

  def attribute_value(attribute)
    return unless has_attribute?(attribute)

    value = public_send(attribute)
    value if value.present?
  end
end
