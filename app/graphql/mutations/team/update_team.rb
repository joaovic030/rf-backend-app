module Mutations
  module Team
    class UpdateTeam < BaseMutation
      argument :id, ID, required: true
      argument :name, String, required: false
      argument :acronym, String, required: false

      type Types::Team::TeamType

      def resolve(**args)
        team = ::Team.find(args[:id])

        team.tap { |team| team.update!(args.except(:id)) }
      end
    end
  end
end