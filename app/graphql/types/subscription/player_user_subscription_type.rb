# frozen_string_literal: true

module Types
  module Subscription
    class PlayerUserSubscriptionType < Types::BaseObject
      implements Types::Support::BasicRecordType

      field :player_id, Int, null: false, description: 'Player id to activate the notification'
      field :user_subscribed, Types::User::UserType, null: true, method: :user
    end
  end
end
