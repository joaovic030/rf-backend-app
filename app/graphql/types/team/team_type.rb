# frozen_string_literal: true

module Types
  module Team
    class TeamType < Types::BaseObject
      implements Types::Support::BasicRecordType

      field :name, String, null: false, description: 'Name of the team'
      field :acronym, String, null: false, description: 'Short name'
    end
  end
end
