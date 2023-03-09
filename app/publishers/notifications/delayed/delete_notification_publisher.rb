# frozen_string_literal: true

module Notifications
  module Delayed
    class DeleteNotificationPublisher
      attr_reader :notification_id

      QUEUE = 'delete_notification'
      EXCHANGE_NAME = 'delayed_messages.subscription'
      ROUTING_KEY = "#{EXCHANGE_NAME}.#{QUEUE}"
      DELAY = 1.minute

      class << self
        def publish(notification_id)
          new(notification_id).publish
        end
      end

      def initialize(notification_id)
        @notification_id = notification_id
      end

      def publish
        Shared::Rabbitmq::Publisher.new(
          **queue_params.merge(payload: payload)
        ).publish
      end

      private

      def queue_params
        {
          queue:         QUEUE,
          exchange_name: EXCHANGE_NAME,
          routing_key:   ROUTING_KEY,
          headers:       { 'x-delay': (DELAY).to_i.in_milliseconds }
        }
      end

      def payload
        { notification_id: notification_id }
      end
    end
  end
end
