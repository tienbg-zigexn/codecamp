Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "pages#index"
  resources :books do
    resources :reviews, only: %i[new create destroy]
  end

  # default rails generated
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
