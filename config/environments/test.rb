require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false

  # Eager loading loads your entire application. When running a single test locally,
  # this is usually not necessary, and can slow down your test suite. However, it's
  # recommended that you enable it in continuous integration systems to ensure eager
  # loading is working properly before deploying your code.
  config.eager_load = ENV["CI"].present?

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Render exception templates for rescuable exceptions and raise for other exceptions.
  config.action_dispatch.show_exceptions = :rescuable

  config.action_controller.allow_forgery_protection = false

  config.active_support.test_order = :random
  config.active_support.deprecation = :raise
  config.active_support.disallowed_deprecation = :raise

  config.active_support.disallowed_deprecation_warnings = []
  config.i18n.raise_on_missing_translations = true

  config.cache_store = :null_store

  # Raise error when a before_action's only/except options reference missing actions.
  config.action_controller.raise_on_missing_callback_actions = true
end
