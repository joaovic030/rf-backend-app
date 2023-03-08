require 'rails_helper'

RSpec.describe NotificationServices::TriggerNotification do
  describe '.run' do
    let!(:player) { create(:player) }
    let!(:players_user_subs) { create_list(:player_user_subscription, 2, player: player) }
    let(:message) { 'There are some changes about the player' }

    let(:trigger_notification) { described_class.run(player_id: player.id, message: message) }

    let(:mock_publisher) do
      Notifications::BroadcastNotificationPublisher
    end

    context 'with required arguments' do
      it 'triggers notifications' do
        expect(mock_publisher).to receive(:publish)
                                    .twice
                                    .with(any_args)
                                    .and_return(true)
        trigger_notification
      end
    end
  end
end