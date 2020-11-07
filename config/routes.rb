Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :users
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  devise_for :users

  resources :bounties, except: [:update, :destroy] do
    member do
      post :approve
      post :reject
    end

    get '/pending_action', on: :collection, to: 'bounties#pending_action'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
