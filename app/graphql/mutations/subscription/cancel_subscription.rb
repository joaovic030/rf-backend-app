module Mutations
  module Subscription
    class CancelSubscription < BaseMutation
      argument :player_id, Int, required: true

      type Types::Subscription::PlayerUserSubscriptionType

      def resolve(player_id:)
        subscription = ::PlayerUserSubscription.find_by!(player_id: player_id, user: context[:current_user])

        PlayerUserSubscription.delete_by(player_id: player_id, user: context[:current_user])

        subscription.freeze
      end
    end
  end
end