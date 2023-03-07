require 'rails_helper'

RSpec.describe Player, type: :model do
  subject(:player) { create(:player) }

  let(:message) { player.track_changes }
  let(:mock_publish_notification) do
    allow(player).to receive(:track_changes).and_return(message)

    allow(Notifications::CreateNotificationPublisher).to receive(:publish)
                                                           .with(
                                                             player_id: player.id,
                                                             message: message
                                                           )
                                                           .and_return(true)
  end

  shared_examples 'player is invalid' do
    it { expect(player).not_to be_valid }
  end

  context 'with valid attributes' do
    it { is_expected.to be_valid }
  end

  context 'with invalid attributes' do
    context 'when name is blank' do
      let(:player) { build(:player, name: nil) }

      it_behaves_like 'player is invalid'
    end

    context 'when position is blank' do
      let(:player) { build(:player, position: nil) }

      it_behaves_like 'player is invalid'
    end
  end

  describe '.track_changes' do
    let!(:player_age) { player.age }
    let!(:player_updated_at) { player.updated_at }

    let(:message) do
      "Player #{player.name} updated. Follow the changes:\n"\
      "age => from: #{player_age} to: #{player.age}\n"\
      "updated_at => from: #{player_updated_at} to: #{player.updated_at}\n"
    end

    context 'when save or update player' do
      before do
        mock_publish_notification

        player.update(age: 30)

        player
      end

      it { expect(player.track_changes).to eq(message) }
      it { expect(player.previous_changes).to have_key(:age) }
      it { expect(player.previous_changes).to have_key(:updated_at) }
      it { expect(player.previous_changes.values.first).to eq([player_age, player.age]) }
      it { expect(player.previous_changes.values.last).to eq([player_updated_at, player.updated_at]) }
    end
  end

  describe '.team' do
    let(:team) { create(:team) }
    let(:player) { create(:player, team: team) }

    it { expect(player.team).to eq(team) }
  end
end
