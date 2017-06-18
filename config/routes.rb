Rails.application.routes.draw do
  resources :people

  post '/confirm', to: 'people#confirm'
  root 'people#index'
end
