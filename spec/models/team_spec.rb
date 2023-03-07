require 'rails_helper'

RSpec.describe Team, type: :model do
  subject(:team) { create(:team) }

  shared_examples 'team is invalid' do
    it { expect(team).not_to be_valid }
  end

  context 'with valid attributes' do
    it { is_expected.to be_valid }
  end

  context 'with invalid attributes' do
    context 'when name is blank' do
      let(:team) { build(:team, name: nil) }

      it_behaves_like 'team is invalid'
    end

    context 'when acronym is blank' do
      let(:team) { build(:team, acronym: nil) }

      it_behaves_like 'team is invalid'
    end
  end

  describe '.players' do
    let(:players) { create_list(:player, 3, team: team) }

    it { expect(team.players).to eq(players) }
  end
end
