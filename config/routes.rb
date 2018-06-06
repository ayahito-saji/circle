Rails.application.routes.draw do
  devise_for :users, controllers: {
      omniauth_callbacks: "omniauth_callbacks"
  }
  root 'pages#index'
  resources :room do
    collection do
      get 'search'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
