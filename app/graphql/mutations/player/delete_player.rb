module Mutations
  module Player
    class DeletePlayer < BaseMutation
      argument :id, ID, required: true

      type Types::Player::PlayerType

      def resolve(**args)
        player = ::Player.find(args[:id])

        player.tap { |player| player.delete }
      end
    end
  end
end