require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module DnOe44RubyFoodAndDrink
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = "Hanoi"
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :en
  end
end
