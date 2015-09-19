Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  mount_griddler

  resources :tasks, except: [:edit, :update] do
    get :send_to_process, on: :member
  end
  root 'tasks#index'
end
