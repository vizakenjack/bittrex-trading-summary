Rails.application.routes.draw do

  devise_for :users
  resources :api do
    post 'sync', on: :member
  end
  resources :exchanges
  resources :orders_histories, only: [:edit, :update, :destroy]

  scope '(:username)' do
    resources :trades do
      get 'debug', on: :collection
    end
  end

  resources :coins do
    get 'load', on: :collection
    post 'load', on: :collection
    delete 'destroy_all', on: :collection, as: "delete"
  end

  get 'console' => 'application#console'
  root to: "application#index"
end
