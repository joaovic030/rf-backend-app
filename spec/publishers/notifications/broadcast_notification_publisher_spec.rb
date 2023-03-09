# frozen_string_literal: true

require 'rails_helper'

describe Notifications::BroadcastNotificationPublisher, type: :publisher do
  subject(:context) { described_class.new(user.id, message) }
  subject(:context_publish) { described_class.publish(user.id, message) }

  let(:user) { create(:user) }
  let(:message) { 'There are some changes about the player' }

  let(:shared_publisher) { instance_double(Shared::Rabbitmq::Publisher) }

  let(:payload_data) do
    {
      user_id: user.id,
      message: message
    }
  end

  describe '#exchange' do
    it { expect(described_class::EXCHANGE_NAME).to eq 'player.subscription' }
  end

  describe '#queue' do
    it { expect(described_class::QUEUE).to eq 'broadcast_notification' }
  end

  describe '#routing_key' do
    it { expect(described_class::ROUTING_KEY).to eq 'player.subscription.broadcast_notification' }
  end

  describe '#payload' do
    shared_examples 'a expected payload' do
      it 'has the expected type and data' do
        expect(context.send(:payload)).to include(type: 'broadcast_notification', data: payload_data)
      end
    end

    context 'when is a single notification' do
      it_behaves_like 'a expected payload'
    end
  end

  describe '#publish' do
    shared_examples 'a called shared publisher' do
      it 'calls shared publisher with correct params', :aggregate_failures do
        expect(Shared::Rabbitmq::Publisher).to have_received(:new).with(
          exchange_name: 'player.subscription',
          queue:         'broadcast_notification',
          routing_key:   'player.subscription.broadcast_notification',
          payload:       {
            type: 'broadcast_notification',
            data: payload_data
          }
        ).once

        expect(shared_publisher).to have_received(:publish).once
      end
    end

    before do
      allow(Shared::Rabbitmq::Publisher).to receive(:new)
                                              .with(an_instance_of(Hash))
                                              .and_return(shared_publisher)

      allow(shared_publisher).to receive(:publish)

      context_publish
    end

    context 'when called to broadcast the message to user' do
      it_behaves_like 'a called shared publisher'
    end
  end
end
