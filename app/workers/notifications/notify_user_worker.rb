module Notifications
  class NotifyUserWorker
    include Sneakers::Worker

    from_queue :broadcast_notification,
               exchange: 'player.subscription',
               routing_key: 'player.subscription.broadcast_notification'

    def work(raw_data)
      data = JSON.parse(raw_data).deep_symbolize_keys

      user = User.find(data[:data][:user_id])

      NotificationMailer.with(user: user, message: data[:data][:message]).send_notification.deliver_now

      ack!
    rescue ActiveRecord::RecordNotFound, _ => _e
      reject!
    end
  end
end