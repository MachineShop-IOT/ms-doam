require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'rubygems'
require 'machineshop'
require 'RMagick'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module DoamApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    MachineShop.api_base_url = "http://stage.services.machineshop.io/api/v1"
    # MachineShop.api_base_url = "http://192.168.88.196:3000/api/v1"

    # mysql for local caching
    MachineShop.configure do |config|
        config.db_name = "machineshop"
        config.db_username="root"
        config.db_password=""
        config.db_host= "localhost"
        config.expiry_time= lambda{120.seconds.ago}
    end

end
end
