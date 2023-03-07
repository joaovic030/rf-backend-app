# frozen_string_literal: true

namespace :rabbitmq do
  desc 'Setup Rabbitmq'

  task setup: :environment do
    include Shared::Rabbitmq::Config::Loadable

    channel = RabbitmqConnectionManager.instance.channel

    config_file[:exchanges].map do |_key, exchange|
      next if exchange[:contexts].nil?

      exchange[:contexts].map do |_key, context|
        next if context.nil?

        puts "Creating exchange #{context[:exchange_name]}\n"
        exchange_created = channel.exchange(context[:exchange_name],
                                            {
                                              durable:   exchange[:durable],
                                              type:      exchange[:type],
                                              arguments: exchange[:arguments]
                                            }.compact)

        context[:queues].map do |_key, context_queue|
          next if context_queue.nil?

          puts "Creating queue #{context_queue[:queue_name]}\n"

          queue = channel.queue(context_queue[:queue_name], durable: context_queue[:durable], arguments: context_queue[:arguments])

          puts "Binding queue #{context_queue[:queue_name]} to exchange #{context[:exchange_name]}\n"

          queue.bind(exchange_created, routing_key: context_queue[:routing_key])

          puts "#{context[:exchange_name]} ==> #{context_queue[:queue_name]}\n\n"
        end
      end
    end

    RabbitmqConnectionManager.instance.connection.close
  end
end
