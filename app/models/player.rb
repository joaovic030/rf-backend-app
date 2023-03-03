class Player < ApplicationRecord
  has_many :player_user_subscriptions
  belongs_to :team, optional: true

  validates :name, :position, presence: true
end
