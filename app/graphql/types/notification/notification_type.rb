# frozen_string_literal: true

module Types
  module Notification
    class NotificationType < Types::BaseObject
      implements Types::Support::BasicRecordType

      field :player_id, Int, null: false, description: 'Player id source of change'
      field :message, String, null: false, description: 'Message with details about the player'
    end
  end
end
