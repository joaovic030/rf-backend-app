module Resolvers
  module Notification
    class NotificationList < Resolvers::Base
      description 'List of notifications'

      type Types::Notification::NotificationType.connection_type, null: true

      def resolve(**args)
        ::Notification.order(:created_at)
      end
    end
  end
end