module Mutations
  module Team
    class DeleteTeam < BaseMutation
      argument :id, ID, required: true

      type Types::Team::TeamType

      def resolve(**args)
        team = ::Team.find(args[:id])

        team.tap { |team| team.delete }
      end
    end
  end
end