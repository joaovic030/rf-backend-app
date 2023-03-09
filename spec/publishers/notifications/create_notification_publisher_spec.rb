# frozen_string_literal: true

require 'rails_helper'

describe Notifications::CreateNotificationPublisher, type: :publisher do
  subject(:context) { described_class.new(player.id, message) }

  let(:context_publish) { described_class.publish(player_id: player.id, message: message) }

  let(:player) { create(:player) }
  let(:message) { 'There are some changes about the player' }

  let(:shared_publisher) { instance_double(Shared::Rabbitmq::Publisher) }

  let(:payload_data) do
    {
      player_id: player.id,
      message:   message
    }
  end

  describe '#exchange' do
    it { expect(described_class::EXCHANGE_NAME).to eq 'player.subscription' }
  end

  describe '#queue' do
    it { expect(described_class::QUEUE).to eq 'create_notification' }
  end

  describe '#routing_key' do
    it { expect(described_class::ROUTING_KEY).to eq 'player.subscription.create_notification' }
  end

  describe '#payload' do
    shared_examples 'a expected payload' do
      it 'has the expected type and data' do
        expect(context.send(:payload)).to include(type: 'create_notification', data: payload_data)
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
          queue:         'create_notification',
          routing_key:   'player.subscription.create_notification',
          payload:       {
            type: 'create_notification',
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

    context 'when called to create a notification' do
      it_behaves_like 'a called shared publisher'
    end
  end
end
