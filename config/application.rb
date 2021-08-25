require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PokerJudgeNp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       controller_specs: false,
                       routing_specs: false
    end
    config.autoloader = :classic
    config.paths.add File.join("app", "apis", "services"), glob: File.join("**", "*.rb")
    config.autoload_paths += Dir[Rails.root.join("app/apis/services/*")]
    config.middleware.use(Rack::Config) do |env|
      env["api.tilt.root"] = Rails.root.join("app/views/api")
    end
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
