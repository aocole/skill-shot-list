require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Skillshot
  require_relative '../lib/block_easou_spider'
  require "rack/contrib/jsonp"
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: 'sub4.mail.dreamhost.com',
      port: 587,
      domain: 'skillshot.ndrew.org',
      authentication: :login,
      user_name: 'no-reply@skillshot.ndrew.org',
      password: 'skillshotmailer'
    }
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    config.assets.initialize_on_precompile = false

    config.middleware.use Rack::BlockEasouSpider
    config.middleware.use Rack::JSONP

    config.action_controller.asset_host = Proc.new { |source, request = nil, *_|
      request ? request.protocol + request.host_with_port : nil
    }
  end
end
