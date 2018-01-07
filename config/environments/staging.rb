require_relative "production"

Rails.application.configure do
  config.force_ssl = false
  config.action_mailer.default_url_options = { host: ENV.fetch("APPLICATION_HOST") }
end
