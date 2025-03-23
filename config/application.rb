require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module HotlineWebring
  class Application < Rails::Application
    config.load_defaults 8.0

    config.i18n.enforce_available_locales = true
    config.assets.quiet = true
    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end
    config.action_controller.action_on_unpermitted_parameters = :raise

    config.closed = ENV.fetch("CLOSED_FOR_REGISTRATION", false) == "1"
    config.disallow_creating_new_redirections = ENV.fetch("DISALLOW_CREATING_NEW_REDIRECTIONS", false) == "1"
  end
end
