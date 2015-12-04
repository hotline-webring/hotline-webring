Rails.application.routes.draw do
  get ":slug/next", to: "redirections#next"
  get ":slug/previous", to: "redirections#previous"

  root "homes#show"
end
