# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Team::UpdateTeam, type: :request do
  include_context 'with graphql query request'

  let!(:team) { create(:team) }

  let(:expected_attrs) do
    {
      id: team.id,
      name: team.name,
      acronym: 'NoNe'
    }
  end


  let(:query) do
    <<-GRAPHQL
      mutation {
        updateTeam(
            id: #{team.id}
            acronym: "NoNe"
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
      it 'updates the team and returns the data' do
        expect(response_data).to include(expected_attrs.merge(id: team.id.to_s))
      end

      it { expect(team.reload).to have_attributes(expected_attrs) }
    end

    context 'when the required arguments are not provided' do
      let(:query) do
        <<-GRAPHQL
          mutation {
            updateTeam(
                acronym: "CBAPT"
            ) {
                id
                name
                acronym
            }
          }
        GRAPHQL
      end

      it 'messages with error' do
        expect(response_errors).to eq("Field 'updateTeam' is missing required arguments: id")
      end
    end
  end

  def response_data
    json_response.dig(:data, :updateTeam)
  end

  def response_errors
    json_response.dig(:errors, 0, :message)
  end
end
