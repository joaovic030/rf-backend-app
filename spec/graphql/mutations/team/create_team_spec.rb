# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Team::CreateTeam, type: :request do
  include_context 'with graphql query request'

  let!(:team) { attributes_for(:team, name: 'Beleneses', acronym: 'BLNES') }

  let(:query) do
    <<-GRAPHQL
      mutation {
        createTeam(
          name: "#{team[:name]}",
          acronym: "#{team[:acronym]}"
        ) {
            id
            name
            acronym
        }
      }
    GRAPHQL
  end

  describe '#resolve' do
    before do
      post_request
    end

    context 'when the required arguments are provided' do
      it 'creates a new team and returns the team object' do
        expect(response_data).to include(team)
      end
    end

    context 'when the required arguments are not provided' do
      let(:query) do
        <<-GRAPHQL
          mutation {
            createTeam(
              name: "#{team[:name]}",
            ) {
                id
                name
                acronym
            }
          }
        GRAPHQL
      end

      it 'messages with error' do
        expect(response_errors).to eq("Field 'createTeam' is missing required arguments: acronym")
      end
    end
  end

  def response_data
    json_response.dig(:data, :createTeam)
  end

  def response_errors
    json_response.dig(:errors, 0, :message)
  end
end
