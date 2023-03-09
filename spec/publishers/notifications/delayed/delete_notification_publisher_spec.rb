# frozen_string_literal: true

require 'rails_helper'

describe Notifications::Delayed::DeleteNotificationPublisher, type: :publisher do
  subject(:context) { described_class.new(notification.id) }
  subject(:context_publish) { described_class.publish(notification.id) }

  let(:notification) { create(:notification) }
  let(:shared_publisher) { instance_double(Shared::Rabbitmq::Publisher) }

  let(:payload_data) do
    {
      notification_id: notification.id,
    }
  end

  describe '#exchange' do
    it { expect(described_class::EXCHANGE_NAME).to eq 'delayed_messages.subscription' }
  end

  describe '#queue' do
    it { expect(described_class::QUEUE).to eq 'delete_notification' }
  end

  describe '#routing_key' do
    it { expect(described_class::ROUTING_KEY).to eq 'delayed_messages.subscription.delete_notification' }
  end

  describe '#delay' do
    it { expect(described_class::DELAY).to eq 1.minute }
  end

  describe '#payload' do
    shared_examples 'a expected payload' do
      it 'has the expected type and data' do
        expect(context.send(:payload)).to include(payload_data)
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
          exchange_name: 'delayed_messages.subscription',
          queue:         'delete_notification',
          routing_key:   'delayed_messages.subscription.delete_notification',
          headers: { 'x-delay': (described_class::DELAY).to_i.in_milliseconds },
          payload: payload_data
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

    context 'when called to delete notification with delay' do
      it_behaves_like 'a called shared publisher'
    end
  end
end
