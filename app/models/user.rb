class User < ApplicationRecord
  has_secure_password

  has_many :player_user_subscriptions
  has_many :subscribed_players, through: :player_user_subscriptions, class_name: 'Player'


  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
