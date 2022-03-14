Rails.application.routes.draw do
  namespace :admin do
    resources :redirections, only: [:index, :edit, :update] do
      resources :blocks, only: [:create]
      resources :unlinks, only: [:create]
    end
    root "redirections#index"
  end

  get "feed", to: "feeds#show", defaults: { format: :atom }
  get ":slug/next", to: "redirections#next"
  get ":slug/previous", to: "redirections#previous"

  root "homes#show"
end
