module Resolvers
  module Player
    class PlayerList < Resolvers::Base
      description 'List of players'

      argument :order_by, type: Types::Player::Enums::OrderBy, required: false, default_value: 'name'

      type Types::Player::PlayerType.connection_type, null: true

      def resolve(**args)
        ::Player.order(args[:order_by].to_sym)
      end
    end
  end
end