Rails.application.routes.draw do
  devise_for :admins

  root to: redirect("/admins/sign_in")

  namespace :admin do
    get :me, to: "auth#me"
    root "dashboard#index"

    resources :enterprises, only: [ :index, :show ] do
      member do
        get :edit_billing
        patch :update_billing
        get :register_payment
        patch :register_payment, action: :update_register_payment
      end
    end
    resources :users, only: [ :index, :show ]
    resources :projects, only: [ :index, :show ]
    resources :subscriptions, only: [ :index ]
    resources :admin_logs, only: [ :index ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
