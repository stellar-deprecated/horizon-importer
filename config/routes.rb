Rails.application.routes.draw do
  root 'welcome#index'
  get 'metrics' => 'metrics#index'

  resources :accounts, only: [:show] do
    resources :transactions, only: [:index]
  end

  resources :transactions, only: [:index, :show]
end
