class Admin::SubscriptionsController < Admin::BaseController
  def index
    @subscriptions = Subscription.all
    @subscriptions = @subscriptions.order(created_at: :desc) if Subscription.column_names.include?("created_at")
    @subscriptions = @subscriptions.page(params[:page]).per(25)
  end
end
