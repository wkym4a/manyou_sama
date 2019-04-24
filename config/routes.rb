Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks do
    collection do
      get :index_search
    end
    member do
      patch :update_status
    end
  end

  resources :users do
    member do
      get :show_after_create
      get :edit_pass
      patch :update_pass
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
end
