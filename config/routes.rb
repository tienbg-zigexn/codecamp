Rails.application.routes.draw do
  resource :session, only: %i[ new create destroy ]
  resource :registration, only: %i[ new create ]
  resources :passwords, param: :token, only: %i[ new create edit update ]
  root "pages#index"
  resources :books do
    resources :reviews, only: %i[new show create destroy]
  end
  resources :users, only: %i[index show] do
    resource :follows, only: %i[create destroy]
    resources :notifications, only: %i[index show] do
      member do
        post 'mark_as_read', to: 'notifications#mark_as_read'
      end
      collection do
        post 'mark_all_as_read', to: 'notifications#mark_all_as_read'
      end
    end
  end

  # default rails generated
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
