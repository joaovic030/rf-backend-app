module NotificationServices
  class Manager
    class << self
      def delete_notification(notification_id)
        new(notification_id).delete_notification
      end
    end

    def initialize(notification_id)
      @notification_id = notification_id
    end

    def delete_notification
      notification.delete
    end

    private

    def notification
      @notification = Notification.find(@notification_id)
    end
  end
end
