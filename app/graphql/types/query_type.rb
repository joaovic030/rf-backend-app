module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :players, resolver: Resolvers::Player::PlayerList
    field :teams, resolver: Resolvers::Team::TeamList
    field :notifications, resolver: Resolvers::Notification::NotificationList
  end
end
