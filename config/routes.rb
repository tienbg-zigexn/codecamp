Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  resources :locations, only: [ :index, :show ] do
    collection do
      get "search"
    end
  end

  root "pages#index"
end
