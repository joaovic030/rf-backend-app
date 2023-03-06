module NotificationServices
  class Manager
    class << self
      def delete(notification_id)
        new(notification_id).delete
      end
    end

    def initialize(notification_id)
      @notification_id = notification_id
    end

    def delete
      notification.delete
    end

    private

    def notification
      @notification ||= Notification.find(@notification_id)
    end
  end
end
