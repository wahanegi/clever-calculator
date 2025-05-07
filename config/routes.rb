Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      resources :quotes, only: [:create, :update] do
        resources :quote_items, only: [:destroy] do
          post :create_from_item, on: :collection
          post :create_from_category, on: :collection
        end
      end
      resources :customers, only: [:index] do
        post :upsert, on: :collection
      end
      resources :categories, only: [:index]
      get 'items/uncategorized', to: 'items#uncategorized'
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root 'homepage#index'
  get "*path", to: "homepage#index", constraints: ->(req) { !req.xhr? && req.format.html? }
end
