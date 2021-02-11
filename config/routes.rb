Rails.application.routes.draw do
  root 'homes#index'
  namespace 'api' do
    namespace 'v1' do
      resources :chat_groups, only: [:index, :show, :create, :update, :destroy] do
        resources :messages, only: [:create]
      end
    end
  end
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
