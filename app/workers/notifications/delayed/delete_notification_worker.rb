module Notifications
  module Delayed
    class DeleteNotificationWorker
      include Sneakers::Worker

      from_queue :delete_notification,
                 exchange: 'delayed_messages.subscription',
                 routing_key: 'delayed_messages.subscription.delete_notification',
                 exchange_options: {
                   type:      'x-delayed-message',
                   arguments: { 'x-delayed-type': 'direct' }
                 }

      def work(raw_data)
        data = JSON.parse(raw_data).deep_symbolize_keys

        NotificationServices::Manager.delete_notification(data[:notification_id])

        ack!
      rescue => _e
        reject!
      end
    end
  end
end