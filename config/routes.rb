Rails.application.routes.draw do

  devise_for :users, controllers: {
      omniauth_callbacks: "omniauth_callbacks"
  }
  root 'pages#index'
  get 'account', to: 'users#show', as: 'current_user'
  get 'room', to: 'rooms#show', as: 'current_room'
  post 'rooms/new', to: 'rooms#create', as: 'new_room'
  post 'rooms/search', to: 'rooms#search', as: 'search_room'
  delete 'rooms/exit', to: 'rooms#destroy', as: 'exit_room'
  resources :rulebooks

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
