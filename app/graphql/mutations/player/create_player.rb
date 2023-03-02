module Mutations
  module Player
    class CreatePlayer < BaseMutation
      argument :name, String, required: true
      argument :position, String, required: true
      argument :number, Int, required: false
      argument :nationality, String, required: false
      argument :age, Int, required: false
      argument :team_id, Int, required: false

      type Types::Player::PlayerType

      def resolve(**args)
        ::Player.create!(args)
      end
    end
  end
end