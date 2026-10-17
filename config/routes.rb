Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  get "/hello", to: "pages#hello"

  resources :articles

  root "articles#index"
end
