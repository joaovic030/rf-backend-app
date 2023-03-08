# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Player::CreatePlayer, type: :request do
  include_context 'with graphql query request'

  let!(:player) { create(:player) }
  let(:expected_attrs) do
    {
      name: 'Silva',
      position: 'G'
    }
  end

  let(:query) do
    <<-GRAPHQL
      mutation {
        createPlayer(
          name: "Silva",
          position: "G"
        ) {
            id
            name
            position
            number
        }
      }
    GRAPHQL
  end

  describe '#resolve' do
    before do
      post_request
    end

    context 'when the required arguments are provided' do
      it 'creates a new player and returns the player object' do
        expect(response_data).to include(expected_attrs)
        expect(response_data).to have_key(:id)
      end
    end

    context 'when the required arguments are not provided' do
      let(:query) do
        <<-GRAPHQL
          mutation {
            createPlayer(
              name: "Silva",
            ) {
                id
                name
                position
                number
            }
          }
        GRAPHQL
      end

      it 'messages with error' do
        expect(response_errors).to eq("Field 'createPlayer' is missing required arguments: position")
      end
    end
  end

  def response_data
    json_response.dig(:data, :createPlayer)
  end

  def response_errors
    json_response.dig(:errors, 0, :message)
  end
end
