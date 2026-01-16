require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WiseinvestApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    # 타임존 설정
    config.time_zone = "Asia/Seoul"

    # 한글 로케일 설정
    config.i18n.default_locale = :ko
    config.i18n.available_locales = [ :ko, :en ]

    # 서비스 디렉토리 오토로드
    config.autoload_paths << Rails.root.join("app/services")
    config.autoload_paths << Rails.root.join("app/clients")
  end
end
