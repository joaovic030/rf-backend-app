class Player < ApplicationRecord
  has_many :player_user_subscriptions
  has_many :notifications, dependent: :delete_all

  belongs_to :team, optional: true

  after_update :publish_notification

  validates :name, :position, presence: true

  def publish_notification
    Notifications::CreateNotificationPublisher.publish(player_id: id, message: track_changes)
  end

  def track_changes
    message = "Player #{name} updated. Follow the changes:\n"
    previous_changes.each_pair do |key, value|
      message += "#{key} => from: #{value.first} to: #{value.last}\n"
    end

    message
  end

  def subscribed?(user_id = nil)
    player_user_subscriptions.exists?(user_id: user_id)
  end
end
