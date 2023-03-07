require 'rails_helper'

RSpec.describe Notification, type: :model do
  subject(:notification) { create(:notification) }

  context 'with valid attributes' do
    it { is_expected.to be_valid }
  end

  describe '.player' do
    it { expect(notification.player).to be_instance_of Player }
    it { expect(notification.player).not_to be_nil  }
  end
end
