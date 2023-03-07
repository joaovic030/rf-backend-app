require 'rails_helper'

RSpec.describe PlayerUserSubscription, type: :model do
  subject(:player_user_subscription) { create(:player_user_subscription) }

  context 'with valid attributes' do
    it { is_expected.to be_valid }
  end

  describe '.player' do
    it { expect(player_user_subscription.player).to be_instance_of Player }
    it { expect(player_user_subscription.player).not_to be_nil  }
  end

  describe '.user' do
    it { expect(player_user_subscription.user).to be_instance_of User }
    it { expect(player_user_subscription.user).not_to be_nil  }
  end
end
