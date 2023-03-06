module Notifications
  class BroadcastNotificationPublisher
    attr_reader :user_id, :message

    QUEUE = 'broadcast_notification'
    EXCHANGE_NAME = 'player.subscription'
    ROUTING_KEY = "#{EXCHANGE_NAME}.#{QUEUE}"

    class << self
      def publish(user_id, message)
        new(user_id, message).publish
      end
    end

    def initialize(user_id, message)
      @user_id = user_id
      @message = message
    end

    def publish
      Shared::Rabbitmq::Publisher.new(
        **queue_params.merge(payload: payload)
      ).publish
    end

    private

    def payload
      {
        type: QUEUE,
        data: payload_data
      }
    end

    def payload_data
      {
        user_id: user_id,
        message: message
      }
    end

    def queue_params
      {
        routing_key:   ROUTING_KEY,
        exchange_name: EXCHANGE_NAME,
        queue:         QUEUE
      }
    end
  end
end