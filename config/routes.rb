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

  resources :users#,only: [:new,:create,:show]
  resources :sessions, only: [:new, :create, :destroy]
end
