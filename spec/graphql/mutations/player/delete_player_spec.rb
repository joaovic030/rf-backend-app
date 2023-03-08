# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Player::DeletePlayer, type: :request do
  include_context 'with graphql query request'

  let(:player) { create(:player, name: 'Silva', position: 'G') }
  let(:expected_attrs) do
    {
      id: player.id.to_s,
      name: 'Silva',
      position: 'G'
    }
  end

  let(:query) do
    <<-GRAPHQL
      mutation {
        deletePlayer(
            id: #{player.id}
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
      post_request
    end

    context 'when the required arguments are provided' do
      it 'deletes a player and returns the player object' do
        expect(response_data).to include(expected_attrs)
      end

      it { expect { player.reload }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when the required arguments are not provided' do
      let(:query) do
        <<-GRAPHQL
          mutation {
            deletePlayer {
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
        expect(response_errors).to eq("Field 'deletePlayer' is missing required arguments: id")
      end
    end
  end

  def response_data
    json_response.dig(:data, :deletePlayer)
  end

  def response_errors
    json_response.dig(:errors, 0, :message)
  end
end
