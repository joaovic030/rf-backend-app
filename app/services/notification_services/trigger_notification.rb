module NotificationServices
  class TriggerNotification
    attr_reader :notification

    class << self
      def run(player_id:, message:)
        new(player_id, message).run
      end
    end

    def initialize(player_id, message)
      @player_id = player_id
      @message = message
    end

    def run
      recipients.each do |subscription|
        Notifications::BroadcastNotificationPublisher.publish(subscription.user_id, @message)
      end
    end

    private

    def recipients
      @recipients ||= PlayerUserSubscription.where(player_id: @player_id)
    end
  end
end
