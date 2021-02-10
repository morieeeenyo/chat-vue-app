Rails.application.routes.draw do
  root 'homes#index'
  namespace 'api' do
    namespace 'v1' do
      resources :chat_groups, only: [:index, :show, :create, :update, :destroy]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
