# frozen_string_literal: true

require 'rails_helper'

describe Resolvers::Team::TeamList, type: :request do
  include_context 'with graphql query request'

  let!(:team) { create(:team, name: 'Benfica') }
  let!(:team2) { create(:team, name: 'Sporting') }

  before do
    post_request
  end

  context 'with no params list teams' do
    let(:query) do
      <<-GRAPHQL
        query {
          teams {
            nodes {
              id
              name
              acronym
            }
          }
        }
      GRAPHQL
    end

    it { expect(response_data.length).to eq 2 }
    it { expect(response_data.pluck(:name)).to match_array(%w[Benfica Sporting]) }
  end


  def response_data
    json_response.dig(:data, :teams, :nodes)
  end
end
