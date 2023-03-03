module Mutations
  module Subscription
    class ActivateSubscription < BaseMutation
      argument :player_id, Int, required: true

      type Types::Subscription::PlayerUserSubscriptionType

      def resolve(player_id:)
        ::PlayerUserSubscription.find_or_create_by!(
          player_id: player_id,
          user: context[:current_user]
        )
      end
    end
  end
end