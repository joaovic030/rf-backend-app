module Notifications
  class CreateNotificationWorker
    include Sneakers::Worker

    from_queue :create_notification,
               exchange: 'player.subscription',
               routing_key: 'player.subscription.create_notification'

    def work(raw_data)
      data = JSON.parse(raw_data).deep_symbolize_keys

      notification_data = notifications_params(data[:data])

      notification_service = NotificationServices::Create.run(**notification_data)

      raise notification_service.errors if notification_service.errors.present?

      NotificationServices::TriggerNotification.run(**notification_data)

      Notifications::Delayed::DeleteNotificationPublisher.publish(notification_service.notification.id)

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