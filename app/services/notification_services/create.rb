module NotificationServices
  class Create
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
      @notification = Notification.create!(
        player_id: @player_id,
        message: @message
      )
    end
  end
end
