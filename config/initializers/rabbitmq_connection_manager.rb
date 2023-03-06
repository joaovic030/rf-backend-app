# frozen_string_literal: true

class RabbitmqConnectionManager
  include Singleton

  attr_accessor :active_connection, :active_channel

  def initialize
    establish_connection
  end

  def connection
    return active_connection if connected?

    establish_connection
    active_connection
  end

  def channel
    return active_channel if connected? && active_channel&.open?

    establish_connection unless connected?
    active_connection.start

    @active_channel = active_connection.create_channel
  end

  private

  def establish_connection
    @active_connection = Bunny.new(
      host:   ENV.fetch('RABBITMQ_HOST') { Rails.application.credentials.dig(Rails.env.to_sym, :rabbitmq, :host) },
      user:   ENV.fetch('RABBITMQ_USER') { Rails.application.credentials.dig(Rails.env.to_sym, :rabbitmq, :user) },
      pass:   ENV.fetch('RABBITMQ_PASS') { Rails.application.credentials.dig(Rails.env.to_sym, :rabbitmq, :pass) },
      port:   ENV.fetch('RABBITMQ_PORT') { Rails.application.credentials.dig(Rails.env.to_sym, :rabbitmq, :port) },
      vhost:  ENV.fetch('RABBITMQ_VHOST') { Rails.application.credentials.dig(Rails.env.to_sym, :rabbitmq, :vhost) },
      mandatory: true,
      logger: Rails.logger
    )
  end

  def connected?
    active_connection&.connected?
  end
end
