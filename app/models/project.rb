class Project < ScrumflowRecord
  belongs_to :enterprise, optional: true

  def display_name
    attribute_value(:name) || attribute_value(:title) || "Projeto ##{id}"
  end

  def attribute_value(attribute)
    return unless has_attribute?(attribute)

    value = public_send(attribute)
    value if value.present?
  end
end
