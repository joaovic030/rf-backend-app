module Mutations
  module Team
    class CreateTeam < BaseMutation
      argument :name, String, required: true
      argument :acronym, String, required: false

      type Types::Team::TeamType

      def resolve(**args)
        ::Team.create!(args)
      end
    end
  end
end