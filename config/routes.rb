Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      resources :quotes, only: [:create, :update, :show] do
        collection do
          get :last
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root 'homepage#index'
  get "*path", to: "homepage#index", constraints: ->(req) { !req.xhr? && req.format.html? }
end
