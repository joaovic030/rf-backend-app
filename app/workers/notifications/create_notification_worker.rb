module Notifications
  class CreateNotificationWorker
    include Sneakers::Worker

    from_queue :create_notification,
               exchange: 'player.subscription',
               routing_key: 'player.subscription.create_notification'

    def work(raw_data)
      byebug
      data = JSON.parse(raw_data).deep_symbolize_keys

      NotificationServices::Create.run(**data)

      Notification::TriggerNotification.run(**data)

      ack!
    rescue => _e
      reject!
    end
  end
end