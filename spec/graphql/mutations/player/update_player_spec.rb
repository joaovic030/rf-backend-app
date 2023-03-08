# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Player::UpdatePlayer, type: :request do
  include_context 'with graphql query request'

  let!(:player) { create(:player, age: 24, number: 6) }
  let(:expected_attrs) do
    {
      id: player.id,
      number: 8,
      age: 25
    }
  end

  let(:mock_publish_notification) do
    allow(player).to receive(:track_changes).and_return(message)

    allow(Notifications::CreateNotificationPublisher).to receive(:publish)
                                                           .with(
                                                             anything
                                                           )
                                                           .and_return(true)
  end


  let(:query) do
    <<-GRAPHQL
      mutation {
        updatePlayer(
          id: #{player.id}
          number: 8
          age: 25
        ) {
            id
            name
            position
            number
            age
        }
      }
    GRAPHQL
  end

  describe '#resolve' do
    before do
      mock_publish_notification

      post_request
    end

    context 'when the required arguments are provided' do
      it 'updates the player and returns the data' do
        expect(response_data).to include(expected_attrs.merge(id: player.id.to_s))
      end

      it { expect(player.reload).to have_attributes(expected_attrs) }
    end

    context 'when the required arguments are not provided' do
      let(:query) do
        <<-GRAPHQL
          mutation {
            updatePlayer(
              number: 7
              age: 30
            ) {
                id
                name
                position
                number
                age
            }
          }
        GRAPHQL
      end

      it 'messages with error' do
        expect(response_errors).to eq("Field 'updatePlayer' is missing required arguments: id")
      end
    end
  end

  def response_data
    json_response.dig(:data, :updatePlayer)
  end

  def response_errors
    json_response.dig(:errors, 0, :message)
  end
end
