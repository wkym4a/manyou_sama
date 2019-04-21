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
end
