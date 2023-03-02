module Mutations
  module Notification
    class CreateNotification < BaseMutation
      argument :player_id, Int, required: true
      argument :message, String, required: true

      type Types::Notification::NotificationType

      def resolve(**args)
        ::Notification.create!(args)
      end
    end
  end
end