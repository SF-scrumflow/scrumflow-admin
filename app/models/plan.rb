class Plan < ScrumflowRecord
  def display_name
    return name if has_attribute?(:name) && name.present?

    "Plano ##{id}"
  end

  def display_price
    price = plan_price
    return "N/A" if price.blank?

    "R$ #{format('%.2f', price.to_f).tr('.', ',')}"
  end

  private

  def plan_price
    if has_attribute?(:price_monthly)
      price_monthly
    elsif has_attribute?(:price)
      price
    end
  end
end
