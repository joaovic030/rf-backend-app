# frozen_string_literal: true

require 'rails_helper'

describe Resolvers::Player::PlayerList, type: :request do
  include_context 'with graphql query request'

  describe '#resolve' do
    before do
      create(:player, name: 'Antonio')
      create(:player, name: 'Ziraldo')

      post_request
    end

    context 'with no params lists players' do
      let(:query) do
        <<-GRAPHQL
        query {
          players {
            nodes {
              id
              name
              position
              number
              age
              nationality
              team {
                  id
                  name
                  acronym
              }
            }
          }
        }
        GRAPHQL
      end

      it 'returns sorted by name asc by default' do
        expect(response_data.pluck(:name)).to eq(%w[Antonio Ziraldo])
      end

      it { expect(response_data.length).to eq 2 }
    end

    context 'with params' do
      let(:query) do
        <<-GRAPHQL
        query {
          players(orderBy: name_desc) {
            nodes {
              id
              name
              position
              number
              age
              nationality
              team {
                  id
                  name
                  acronym
              }
            }
          }
        }
        GRAPHQL
      end

      context 'when ordered by name in descending order' do
        let(:variables) { { orderBy: 'name_desc' } }

        it 'lists players sorted by name desc' do
          expect(response_data.pluck(:name)).to eq(%w[Ziraldo Antonio])
        end
      end

      context 'when paginate' do
        let(:variables) { { skip: 2, limit: 2 } }

        let(:query) do
          <<-GRAPHQL
        query {
          players(skip: 2, limit: 2) {
            nodes {
              id
              name
              position
              number
              age
              nationality
              team {
                  id
                  name
                  acronym
              }
            }
          }
        }
          GRAPHQL
        end

        before do
          create(:player, name: 'Bruno')
          create(:player, name: 'Joao')

          post_request
        end

        it 'returns a list of players with skipped and limited results' do
          expect(response_data.pluck(:name)).to eq(%w[Joao Ziraldo])
          expect(response_data.length).to eq(2)
        end
      end
    end
  end

  def response_data
    json_response.dig(:data, :players, :nodes)
  end
end
