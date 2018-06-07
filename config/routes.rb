Rails.application.routes.draw do
  devise_for :users, controllers: {
      omniauth_callbacks: "omniauth_callbacks"
  }
  root 'pages#index'
  post 'room/new', to: 'room#create'
  post 'room/search', to: 'room#search'
  delete 'room/exit', to: 'room#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
