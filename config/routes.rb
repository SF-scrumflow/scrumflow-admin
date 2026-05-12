Rails.application.routes.draw do
  devise_for :admins

  namespace :admin do
    get :me, to: "auth#me"
    root "dashboard#index"

    resources :enterprises, only: [:index, :show]
    resources :users, only: [:index, :show]
    resources :projects, only: [:index, :show]
    resources :subscriptions, only: [:index]
    resources :admin_logs, only: [:index]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
