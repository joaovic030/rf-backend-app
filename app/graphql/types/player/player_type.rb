# frozen_string_literal: true

module Types
  module Player
    class PlayerType < Types::BaseObject
      implements Types::Support::BasicRecordType

      field :name, String, null: false, description: 'Players name'
      field :number, Int, null: true, description: 'Players number'
      field :nationality, String, null: true, description: 'Players nationality'
      field :age, Int, null: true, description: 'Players age in years'
      field :position, String, null: false, description: 'In which position this player plays'
      field :team_id, Int, null: true, description: 'Team ID'
      field :team, Types::Team::TeamType, null: true, description: 'Team which this player plays for'
    end
  end
end
