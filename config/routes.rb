Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :users do
        post "sign_in", to: "sessions#sign_in"
        post "sign_up", to: "sessions#sign_up"
        delete "sign_out", to: "sessions#sign_out"
        get "me", to: "sessions#me"
      end
    end
  end
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
