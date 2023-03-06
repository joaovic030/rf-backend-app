# frozen_string_literal: true

module Shared
  module Rabbitmq
    class Publisher
      class ConfigurationNotFoundError < StandardError; end
      include Config::Loadable

      attr_reader :channel, :exchange, :routing_key, :queue, :headers, :payload

      def initialize(channel_singleton = RabbitmqConnectionManager, exchange_name:, routing_key:, queue:, payload:, headers: {})
        @queue = queue
        @payload = payload
        @routing_key = routing_key
        @headers = headers
        @channel_singleton = channel_singleton
        check_config_exists!(exchange_name)
        @exchange = fetch_exchange(exchange_name)
      end

      def publish
        exchange.publish(
          payload.to_json,
          routing_key:  routing_key,
          headers:      headers,
          content_type: 'application/json',
          timestamp:    Time.zone.now.to_i
        )
      ensure
        channel.close
      end

      private

      def check_config_exists!(exchange_name)
        exchange_name, context = split_exchange_name(exchange_name)
        queue_config = fetch_queue_config(exchange_name: exchange_name, context: context, queue_name: queue)

        return if queue_config.present?

        raise ConfigurationNotFoundError, 'Configuration not found'
      end

      def fetch_exchange(exchange_name)
        channel.exchange(exchange_name, **exchange_config(exchange_name))
      end

      def exchange_config(exchange_name)
        exchange_name, = split_exchange_name(exchange_name)
        fetch_exchange_config(exchange_name).slice(:durable, :type, :arguments)
      end

      def split_exchange_name(exchange_name)
        exchange_name.split('.')
      end

      def channel
        @channel ||= @channel_singleton.instance.channel
      end
    end
  end
end
