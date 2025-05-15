Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      resources :quotes, only: [:create, :update, :destroy] do
        member do
          patch :reset
          get :generate_file
        end
        resources :quote_items, only: [:update, :index] do
          collection do
            post :create_from_item
            post :create_from_category
            delete :destroy_selected
          end
          post :duplicate, on: :member
          resource :note, only: [], controller: 'notes' do
            post :upsert
          end
        end
      end
      resources :selectable_options, only: [:index]
      resource :setting, only: [:show]
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
