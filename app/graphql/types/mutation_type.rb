module Types
  class MutationType < Types::BaseObject
    # Players
    field :create_player, mutation: Mutations::Player::CreatePlayer
    field :update_player, mutation: Mutations::Player::UpdatePlayer
    field :delete_player, mutation: Mutations::Player::DeletePlayer

    # Teams
    field :create_team, mutation: Mutations::Team::CreateTeam
    field :update_team, mutation: Mutations::Team::UpdateTeam
    field :delete_team, mutation: Mutations::Team::DeleteTeam

    # Notifications
    field :create_notification, mutation: Mutations::Notification::CreateNotification
  end
end
