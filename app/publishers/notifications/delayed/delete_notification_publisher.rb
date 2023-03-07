# frozen_string_literal: true

module Notifications
  module Delayed
    class DeleteNotificationPublisher
      attr_reader :notification_id

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
          queue:         'delete_notification',
          exchange_name: 'delayed_messages.subscription',
          routing_key:   'delayed_messages.subscription.delete_notification',
          headers:       { 'x-delay': (DELAY).to_i.in_milliseconds }
        }
      end

      def payload
        { notification_id: notification_id }
      end
    end
  end
end
