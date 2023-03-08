require 'rails_helper'

RSpec.describe NotificationServices::Manager do
  describe '.delete' do
    let!(:notification) { create(:notification) }
    let(:delete_notification) { described_class.delete_notification(notification.id) }

    context 'with required arguments' do
      it 'returns the same object deleted' do
        expect(delete_notification).to be_a(Notification)
      end

      it { expect { delete_notification }.to change(Notification, :count).by(-1) }
    end
  end
end