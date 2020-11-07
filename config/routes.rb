Rails.application.routes.draw do
  resources :users
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  devise_for :users

  resources :bounties do
    member do
      post :approve
      post :reject
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
