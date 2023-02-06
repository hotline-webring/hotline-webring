Rails.application.routes.draw do
  namespace :admin do
    resources :redirections, only: [:index, :edit, :update] do
      resources :blocks, only: [:create]
      resources :unlinks, only: [:create]
    end
    root "redirections#index"
  end

  namespace :api do
    # We use the *slug* as the redirection ID because the Slack bot (this
    # API's only user) can only get the slug right now.
    resources :redirections, only: [], param: :slug do
      resources :blocks, only: [:create]
      resources :unlinks, only: [:create]
    end
  end

  get "feed", to: "feeds#show", defaults: { format: :atom }
  get ":slug/next", to: "redirections#next"
  get ":slug/previous", to: "redirections#previous"
  resources :existing_slugs, only: :show

  root "homes#show"
end
