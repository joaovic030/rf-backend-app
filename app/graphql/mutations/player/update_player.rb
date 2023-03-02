module Mutations
  module Player
    class UpdatePlayer < BaseMutation
      argument :id, ID, required: true
      argument :name, String, required: false
      argument :position, String, required: false
      argument :number, Int, required: false
      argument :nationality, String, required: false
      argument :age, Int, required: false
      argument :team_id, Int, required: false

      type Types::Player::PlayerType

      def resolve(**args)
        player = ::Player.find(args[:id])

        player.tap { |player| player.update!(args.except(:id)) }
      end
    end
  end
end