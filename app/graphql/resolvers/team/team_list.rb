module Resolvers
  module Team
    class TeamList < Resolvers::Base
      description 'List of teams'

      type Types::Team::TeamType.connection_type, null: true

      def resolve
        ::Team.order(created_at: :desc)
      end
    end
  end
end