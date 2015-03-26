Rails.application.routes.draw do
  root 'welcome#index'
  post 'friendbot' => 'welcome#friendbot'

  get 'metrics' => 'metrics#index'

  resources :accounts, only: [:show] do
    resources :transactions, only: [:index]
  end

  resources :transactions, only: [:create, :index, :show]


  match '*path' => 'welcome#not_found', via: :all
end
