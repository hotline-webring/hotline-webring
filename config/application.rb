require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HotlineWebring
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    config.i18n.enforce_available_locales = true
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.closed = ENV.fetch("CLOSED_FOR_REGISTRATION", false) == "1"
    config.disallow_creating_new_redirections = ENV.fetch("DISALLOW_CREATING_NEW_REDIRECTIONS", false) == "1"
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Silence deprecation warnings from dependencies (i.e. not in code we wrote).
    # This silences dartsass's warning about `@import` in `normalize-rails` (which we can't fix on
    # our side).
    # https://github.com/tablecheck/dartsass-sprockets?tab=readme-ov-file#silencing-deprecation-warnings
    config.sass.quiet_deps = true
  end
end
