# frozen_string_literal: true

module Shared
  module Rabbitmq
    module Config
      module Loadable
        def fetch_queue_config(exchange_name:, context:, queue_name:)
          config_file.dig(:exchanges, exchange_name&.to_sym, :contexts, context&.to_sym, :queues,
                          queue_name&.to_sym)&.merge(exchange_name: fetch_context_config(exchange_name, context)[:exchange_name])
        end

        def fetch_context_config(exchange_name, context)
          config_file.dig(:exchanges, exchange_name&.to_sym, :contexts, context&.to_sym)
        end

        def fetch_exchange_config(exchange_name)
          config_file.dig(:exchanges, exchange_name&.to_sym)
        end

        def config_file
          rabbitmq_contexts_file = File.join(Rails.root, 'config', 'rabbitmq.yml')

          @config_file ||= YAML.safe_load(ERB.new(File.read(rabbitmq_contexts_file)).result, aliases: true)
                               .deep_symbolize_keys
        end

        class << self
          attr_reader :config_file
        end
      end
    end
  end
end
