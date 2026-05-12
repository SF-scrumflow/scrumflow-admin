class Plan < ScrumflowRecord
  def display_name
    return name if has_attribute?(:name) && name.present?

    "Plano ##{id}"
  end
end
