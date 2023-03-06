class Player < ApplicationRecord
  has_many :player_user_subscriptions
  belongs_to :team, optional: true

  after_save :publish_notification

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
end
