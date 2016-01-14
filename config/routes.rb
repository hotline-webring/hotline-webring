Rails.application.routes.draw do
  get "feed", to: "feeds#show", defaults: { format: :atom }
  get ":slug/next", to: "redirections#next"
  get ":slug/previous", to: "redirections#previous"

  root "homes#show"
end
