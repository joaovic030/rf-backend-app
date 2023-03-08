# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Subscription::ActivateSubscription, type: :request do
  include_context 'with graphql query request'
  include_context 'login graphql request'

  let!(:player) { create(:player) }
  let!(:user) { create(:user) }
  let!(:subscription_count) { PlayerUserSubscription.count }

  let(:expected_attrs) do
    {
      playerId: player.id,
      userSubscribed: {
        id: user.id.to_s,
        name: user.name,
        email: user.email
      },
    }
  end

  let(:query) do
    <<-GRAPHQL
      mutation {
        activateSubscription(
          playerId: #{player.id}
        )
        {
          playerId,
          userSubscribed {
              id
              name
              email
          }
        }
      }
    GRAPHQL
  end

  let(:login) do
    <<-GRAPHQL
      mutation {
        signinUser(
          credentials: {
              email: "#{user.email}",
              password: "#{user.password}"
          }
        ) {
          token
          user {
              id
              email
          }
        }
      }
    GRAPHQL
  end


  describe '#resolve' do
    before do
      # signIn before other actions that needs authentication
      sign_in

      post_request
    end

    context 'when user logged in and the required arguments are provided' do
      it 'creates association which activate user subscription' do
        expect(response_data).to include(expected_attrs)
      end

      it { expect(PlayerUserSubscription.count).to be > subscription_count }
    end

    context 'when the required arguments are not provided' do
      let(:query) do
        <<-GRAPHQL
          mutation {
            activateSubscription
            {
              playerId,
              userSubscribed {
                id
                name
                email
              }
            }
          }
        GRAPHQL
      end

      it 'messages with error' do
        expect(response_errors).to eq("Field 'activateSubscription' is missing required arguments: playerId")
      end
    end
  end

  context 'when user not logged in' do
    before do
      post_request
    end

    it 'messages with error' do
      expect(response_errors).to include('User must exist')
    end
  end

  def response_data
    json_response.dig(:data, :activateSubscription)
  end

  def response_errors
    json_response.dig(:errors, 0, :message)
  end
end
