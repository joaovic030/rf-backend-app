# frozen_string_literal: true

require 'sneakers'
# require 'sneakers/handlers/maxretry'
require 'sneakers/metrics/logging_metrics'

Sneakers.configure(
  connection: RabbitmqConnectionManager.instance.connection,
  metrics:    Sneakers::Metrics::LoggingMetrics.new,
  workers:    ENV.fetch('SNEAKERS_WORKER', 4).to_i,
  threads:    ENV.fetch('SNEAKERS_THREADS', 5).to_i,
  prefetch:   ENV.fetch('SNEAKERS_THREADS', 5).to_i,
  durable:    true,
  ack:        true,
  env:        ENV.fetch('RAILS_ENV', 'development')
)
Sneakers.logger = Rails.logger
Sneakers.logger.level = Logger::INFO

# Sneakers.configure(
#   connection: RabbitmqConnectionManager.instance.connection,
#   runner_config_file: nil,                             # A configuration file (see below)
#   metrics: Sneakers::Metrics::LoggingMetrics.new,
#   workers: ENV.fetch('SNEAKERS_WORKER', 4).to_i,
#   prefetch: ENV.fetch('SNEAKERS_THREADS', 5).to_i,
#   threads: ENV.fetch('SNEAKERS_THREADS', 5).to_i,
#   timeout_job_after: 2.minutes,                        # Maximal seconds to wait for job
#   env: ENV['RAILS_ENV'],                               # Environment
#   durable: true,                                       # Is queue durable?
#   ack: true,                                           # Must we acknowledge?
#   handler: Sneakers::Handlers::Maxretry,
#   retry_max_times: 3,                                  # how many times to retry the failed worker process
#   retry_timeout: 3 * 60 * 1000                         # how long between each worker retry duration
# )
# Sneakers.logger = Rails.logger
# Sneakers.logger.level = Logger::INFO