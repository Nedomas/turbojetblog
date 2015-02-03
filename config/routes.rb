Rails.application.routes.draw do
  root 'posts#index'
  get 'posts/:slug' => 'posts#show'

  get 'upload' => 'uploads#propose'
  post 'uploads/upload'
end
