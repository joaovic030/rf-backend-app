class Player < ApplicationRecord
  has_many :player_user_subscriptions
  belongs_to :team, optional: true

  after_update :publish_notification

  validates :name, :position, presence: true

  def publish_notification
    Notifications::CreateNotificationPublisher.publish(player_id: id, message: track_changes)
  end

  def track_changes
    "Player #{name} updated. Follow the changes:\n".tap do |text|
      previous_changes.each_pair do |key, value|
        text += "#{key} => from: #{value.first} to: #{value.last}\n"
      end
    end
  end
end
