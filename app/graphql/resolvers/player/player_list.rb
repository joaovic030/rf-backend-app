module Resolvers
  module Player
    class PlayerList < Resolvers::Base
      description 'List of players'

      argument :order_by,
               type: Types::Player::Enums::OrderBy,
               required: false,
               default_value: 'name_asc'
      argument :skip, Int, required: false
      argument :limit, Int, required: false

      type Types::Player::PlayerType.connection_type, null: true

      def resolve(**args)
        ordering_key, order_direction = args[:order_by].split('_').map(&:downcase)

        players = ::Player.order(ordering_key => order_direction)

        return players.offset(args[:skip]).limit(args[:limit]) if args[:skip] && args[:limit]

        players
      end
    end
  end
end