# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Notification::CreateNotification, type: :request do
  let!(:player) { create(:player) }
  let(:expected_attrs) do
    {
      playerId: player.id,
      message: 'Lorem ipsum'
    }
  end

  include_context 'with graphql query request'

  let(:query) do
    <<-GRAPHQL
      mutation {
        createNotification(
            playerId: #{player.id},
            message: "Lorem ipsum"
        ) {
            id
            playerId
            message
            createdAt
        }
      }
    GRAPHQL
  end

  describe '#resolve' do
    before do
      post_request
    end

    context 'when the required arguments are provided' do
      it 'creates a new notification and returns the notification object' do
        expect(response_data).to include(expected_attrs)
        expect(response_data).to have_key(:id)
      end
    end

    context 'when the required arguments are not provided' do
      let(:query) do
      <<-GRAPHQL
        mutation {
          createNotification(
            message: "Lorem ipsum"
          ) {
              id
              playerId
              message
              createdAt
            }
        }
      GRAPHQL
      end

      it 'messages with error' do
        expect(response_errors).to eq("Field 'createNotification' is missing required arguments: playerId")
      end
    end
  end

  def response_data
    json_response.dig(:data, :createNotification)
  end

  def response_errors
    json_response.dig(:errors, 0, :message)
  end
end
