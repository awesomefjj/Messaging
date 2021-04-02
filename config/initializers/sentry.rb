require 'raven/base'
if ENV['SENTRY_DSN'].present?
  require 'sentry-raven'
  Raven.configure do |config|
    config.async = lambda { |event|
      SentryJob.perform_later(event)
    }
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = [:active_support_logger]
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    config.release = ENV['RELEASE_COMMIT']
    config.environments = %w[dev staging production]
  end
end
