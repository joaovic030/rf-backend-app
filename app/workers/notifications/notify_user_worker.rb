module Notifications
  class NotifyUserWorker
    include Sneakers::Worker

    from_queue :broadcast_notification,
               exchange: 'player.subscription',
               routing_key: 'player.subscription.broadcast_notification'

    def work(raw_data)
      data = notification_user_params(raw_data)

      user = User.find(data[:user_id])

      NotificationMailer.with(user: user, message: data[:message]).send_notification.deliver_now

      ack!
    rescue ActiveRecord::RecordNotFound, _ => _e
      reject!
    end

    def notification_user_params(raw_data)
      data = JSON.parse(raw_data).deep_symbolize_keys

      {
        user_id: data[:data][:user_id],
        message: data[:data][:message],
        notification_id: data[:data][:notification_id]
      }
    end
  end
end