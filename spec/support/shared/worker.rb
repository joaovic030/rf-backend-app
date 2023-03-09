# frozen_string_literal: true

RSpec.shared_examples 'a worker bound to an exchange' do
  it { expect(queue.name).to eq(queue_name) }
  it { expect(queue.opts[:exchange]).to eq(exchange_name) }
  it { expect(queue.opts[:routing_key]).to eq(routing_key) }
end