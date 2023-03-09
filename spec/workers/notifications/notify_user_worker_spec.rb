# frozen_string_literal: true

require 'rails_helper'


describe Notifications::NotifyUserWorker, type: :worker do
  subject(:context) { described_class.new.work({ data: payload }.to_json) }

  let(:user) { create(:user) }
  let(:notification) { create(:notification, message: message) }
  let(:message) { 'There are some changes about the player' }

  let(:payload) do
    {
      user_id: user.id,
      message: message,
      notification_id: notification.id
    }
  end

  let(:notification_mailer) { NotificationMailer }

  describe 'create_notification queue' do
    subject(:queue) { described_class.new.queue }

    let(:queue_name)    { 'broadcast_notification' }
    let(:exchange_name) { 'player.subscription' }
    let(:routing_key)   { 'player.subscription.broadcast_notification' }

    it_behaves_like 'a worker bound to an exchange'
  end

  describe '#work' do
    context 'when flow is successful' do
      it { expect(context).to eq(:ack) }
    end

    context 'when flow fails' do
      let(:payload) do
        {
          message: message,
          notification_id: notification.id
        }
      end

      it { expect(context).to eq(:reject) }
    end
  end
end
