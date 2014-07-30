require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trading
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Moscow'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # I18n.enforce_available_locales = true
    config.autoload_paths << Rails.root.join('lib')
    # config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.i18n.default_locale = :en
    
    config.generators.stylesheets = false
    config.generators.javascripts = false
  end
end
