# frozen_string_literal: true

require 'rails_helper'


describe Notifications::CreateNotificationWorker, type: :worker do
  subject(:context) { described_class.new.work({ data: payload }.to_json) }

  let(:player) { create(:player) }
  let(:notification) { create(:notification, player: player, message: message) }
  let(:message) { 'There are some changes about the player' }

  let(:payload) do
    {
      player_id: player.id,
      message: message
    }
  end

  let(:create_service) { NotificationServices::Create }
  let(:stub_create_service) { double(NotificationServices::Create, {
    notification: notification,
    errors: nil
  }) }
  let(:trigger_service) { NotificationServices::TriggerNotification }
  let(:delete_publisher) { Notifications::Delayed::DeleteNotificationPublisher }

  describe 'create_notification queue' do
    subject(:queue) { described_class.new.queue }

    let(:queue_name)    { 'create_notification' }
    let(:exchange_name) { 'player.subscription' }
    let(:routing_key)   { 'player.subscription.create_notification' }

    it_behaves_like 'a worker bound to an exchange'
  end

  describe '#work' do
    before do
      allow(create_service).to receive(:run).with(any_args).and_return(stub_create_service)

      allow(trigger_service).to receive(:run).with(any_args).and_return(true)

      allow(delete_publisher).to receive(:publish).with(notification.id).and_return(true)
    end

    context 'when flow is successful' do
      it { expect(context).to eq(:ack) }
    end

    context 'when flow fails' do
      let(:stub_create_service) { double(NotificationServices::Create, {
        id: notification.id,
        errors: 'User must be present'
      }) }

      it { expect(context).to eq(:reject) }
    end
  end
end
