Rails.application.routes.draw do
  namespace :v1 do
    resources :clients, only: [:show, :create, :destroy], param: :name, as: :clients
    get '/countries/' => 'countries#show'
  end
end
