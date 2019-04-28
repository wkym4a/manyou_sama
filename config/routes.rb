Rails.application.routes.draw do
  root 'tasks#index'

  get 'tops/no_authority', to: 'tops#no_authority' , as: 'no_authority'

  resources :tasks do
    collection do
      get :index_search
    end
    member do
      patch :update_status
    end
  end

  resources :users , only: [:new,:create,:show]
  namespace :admin do
    resources :users , only: [:index,:new,:create,:edit,:destroy,:update,:show] do
      member do
        get :edit_password
        patch :update_password
      end
    end
  end

  resources :sessions, only: [:new, :create, :destroy]

end
