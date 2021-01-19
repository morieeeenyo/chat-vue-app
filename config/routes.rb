Rails.application.routes.draw do
  root 'homes#index'
  resources :chat_groups, only: :create
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
