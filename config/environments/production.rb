require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false

  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.force_ssl = ENV.fetch("USE_SSL", false)
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  config.middleware.use Rack::Deflater
  config.middleware.use Rack::CanonicalHost, ENV.fetch("APPLICATION_HOST")
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = :debug
  config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))
  config.i18n.fallbacks = true
  # Don't log any deprecations.
  config.active_support.report_deprecations = false
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false

  # Show all attributes when inspecting objects in production.
  # (The default in Rails 8 is [:id], but showing an object isn't slow in our
  # app, so we can look at every attribute.)
  config.active_record.attributes_for_inspect = :all
  config.log_tags = [:request_id]

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
