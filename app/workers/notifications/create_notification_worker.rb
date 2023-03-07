module Notifications
  class CreateNotificationWorker
    include Sneakers::Worker

    from_queue :create_notification,
               exchange: 'player.subscription',
               routing_key: 'player.subscription.create_notification'

    def work(raw_data)
      data = JSON.parse(raw_data).deep_symbolize_keys

      notification_data = notifications_params(data[:data])

      notification = NotificationServices::Create.run(**notification_data)

      NotificationServices::TriggerNotification.run(**notification_data)

      Notifications::Delayed::DeleteNotificationPublisher.publish(notification.id)

      ack!
    rescue => _e
      reject!
    end

    def notifications_params(data)
      {
        player_id: data[:player_id],
        message: data[:message]
      }
    end
  end
end