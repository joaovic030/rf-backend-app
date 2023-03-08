# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Team::DeleteTeam, type: :request do
  include_context 'with graphql query request'

  let(:team) { create(:team) }

  let(:expected_attrs) do
    {
      id: team.id.to_s,
      name: team.name,
      acronym: team.acronym
    }
  end

  let(:query) do
    <<-GRAPHQL
      mutation {
        deleteTeam(
            id: #{team.id}
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
      it 'deletes a team and returns the team object' do
        expect(response_data).to include(expected_attrs)
      end

      it { expect { team.reload }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when the required arguments are not provided' do
      let(:query) do
        <<-GRAPHQL
          mutation {
            deleteTeam {
                id
                name
                acronym
            }
          }
        GRAPHQL
      end

      it 'messages with error' do
        expect(response_errors).to eq("Field 'deleteTeam' is missing required arguments: id")
      end
    end
  end

  def response_data
    json_response.dig(:data, :deleteTeam)
  end

  def response_errors
    json_response.dig(:errors, 0, :message)
  end
end
