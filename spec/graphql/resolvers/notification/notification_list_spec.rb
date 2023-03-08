# frozen_string_literal: true

require 'rails_helper'

describe 'NotificationList', type: :request do
  include_context 'with graphql query request'

  let!(:notification) { create(:notification) }

  before do
    post_request
  end

  describe '#resolve' do
    context 'with no params list notifications' do
      let(:query) do
        <<-GRAPHQL
        query {
          notifications {
            nodes {
              id
              playerId
              message
            }
          }
        }
        GRAPHQL
      end

      it { expect(response_data.length).to eq 1 }
    end
  end

  def response_data
    json_response.dig(:data, :notifications, :nodes)
  end
end
