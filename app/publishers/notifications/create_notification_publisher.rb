module Notifications
  class CreateNotificationPublisher
    attr_reader :player_id, :message

    QUEUE = 'create_notification'
    EXCHANGE_NAME = 'player.subscription'
    ROUTING_KEY = "#{EXCHANGE_NAME}.#{QUEUE}"

    class << self
      def publish(player_id:, message:)
        new(player_id, message).publish
      end
    end

    def initialize(player_id, message)
      @player_id = player_id
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
        player_id: player_id,
        message:   message
      }
    end

    def queue_params
      {
        routing_key:   ROUTING_KEY,
        exchange_name: EXCHANGE_NAME,
        queue:         QUEUE,
      }
    end
  end
end