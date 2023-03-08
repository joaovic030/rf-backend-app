module Mutations
  module Subscription
    class CancelSubscription < BaseMutation
      argument :player_id, Int, required: true

      type Types::Subscription::PlayerUserSubscriptionType

      def resolve(player_id:)
        subscription = ::PlayerUserSubscription.find_by!(player_id: player_id, user: context[:current_user])

        PlayerUserSubscription.delete_by(player_id: player_id, user: context[:current_user])

        subscription.freeze

      rescue ActiveRecord::RecordNotFound => e
        build_errors(e)
        return
      end

      def build_errors(e)
        context.add_error(GraphQL::ExecutionError.new(e.message, extensions: { code: 'USER_INPUT_ERROR', attribute: 'user_id' }))
      end
    end
  end
end