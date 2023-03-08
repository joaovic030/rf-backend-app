require 'rails_helper'

RSpec.describe NotificationServices::Create do
  describe '.run' do
    let(:player) { create(:player) }
    let(:message) { 'There are some changes about the player' }
    let(:run_notification) { described_class.run(player_id: player.id, message: message) }

    context 'with required arguments' do
      it 'creates a notification' do
        expect(Notification).to receive(:create!).with(player_id: player.id, message: message)
        run_notification
      end

      it 'returns a new instance of the class' do
        expect(run_notification.notification).to be_a(Notification)
      end

      it { expect { run_notification }.to change(Notification, :count).by(1) }
    end

    context 'when required arguments are not present' do
      let(:run_notification) { described_class.run(player_id: nil, message: message) }

      it 'messages errors' do
        expect(run_notification.errors).to eq('Validation failed: Player must exist')
      end

      it { expect { run_notification }.not_to change(Notification, :count) }
      it { expect(run_notification).not_to eq(Notification.last) }
    end
  end
end