# frozen_string_literal: true

require 'rails_helper'


describe Notifications::Delayed::DeleteNotificationWorker, type: :worker do
  subject(:context) { described_class.new.work(payload.to_json) }

  let(:user) { create(:user) }
  let(:notification) { create(:notification, message: message) }
  let(:message) { 'There are some changes about the player' }

  let(:payload) do
    {
      notification_id: notification.id
    }
  end

  let(:notification_mailer) { NotificationMailer }

  describe 'create_notification queue' do
    subject(:queue) { described_class.new.queue }

    let(:queue_name)    { 'delete_notification' }
    let(:exchange_name) { 'delayed_messages.subscription' }
    let(:routing_key)   { 'delayed_messages.subscription.delete_notification' }

    it_behaves_like 'a worker bound to an exchange'
    it { expect(queue.opts[:exchange_options][:type]).to eq('x-delayed-message') }
    it { expect(queue.opts[:exchange_options][:arguments]).to include('x-delayed-type': 'direct') }
  end

  describe '#work' do
    context 'when flow is successful' do
      it { expect(context).to eq(:ack) }
    end

    context 'when flow fails' do
      let(:payload) do
        {
          notification_id: nil
        }
      end

      it { expect(context).to eq(:reject) }
    end
  end
end
