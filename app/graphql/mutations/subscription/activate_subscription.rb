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

      rescue ActiveRecord::RecordInvalid => e
        build_errors(e&.record || e.model)
        return
      end

      def build_errors(model)
        model.errors.map do |error|
          message = error.attribute.to_s.capitalize + ' ' + error.message
          context.add_error(GraphQL::ExecutionError.new(message, extensions: { code: 'USER_INPUT_ERROR', attribute: error.attribute }))
        end
      end
    end
  end
end