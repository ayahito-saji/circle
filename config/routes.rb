Rails.application.routes.draw do

  devise_for :users, controllers: {
      omniauth_callbacks: "omniauth_callbacks"
  }
  root 'pages#index'
  get 'account', to: 'users#show', as: 'current_user'
  get 'room', to: 'room#show', as: 'current_room'
  post 'room/new', to: 'room#create', as: 'new_room'
  post 'room/search', to: 'room#search', as: 'search_room'
  delete 'room/exit', to: 'room#destroy', as: 'exit_room'
  resources :rulebooks

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
