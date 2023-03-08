# frozen_string_literal: true

require 'rails_helper'

describe Mutations::User::CreateUser, type: :request do
  include_context 'with graphql query request'

  let!(:user) { attributes_for(:user) }
  let(:expected_attrs) do
    {
      name: user[:name],
      email: user[:email]
    }
  end

  let(:query) do
    <<-GRAPHQL
      mutation {
        createUser(
          name: "#{user[:name]}",
          authProvider: {
            credentials: {
              email: "#{user[:email]}",
              password: "#{user[:password]}"
            }
          }
        ) {
          id
          name
          email
        }
      }
    GRAPHQL
  end

  describe '#resolve' do
    before do
      post_request
    end

    context 'when the required arguments are provided' do
      it 'creates a new user and returns the user object' do
        expect(response_data).to include(expected_attrs)
      end
    end

    context 'when the required arguments are not provided' do
      let(:query) do
        <<-GRAPHQL
          mutation {
            createUser(
              name: "New user",
              authProvider: {
                credentials: {
                  email: "user@email.com",
                }
              }
            ) {
              id
              name
              email
            }
          }
        GRAPHQL
      end

      it 'messages with error' do
        expect(response_errors).to eq("Argument 'password' on InputObject 'AUTH_PROVIDER_CREDENTIALS' is required. Expected type String!")
      end
    end
  end

  def response_data
    json_response.dig(:data, :createUser)
  end

  def response_errors
    json_response.dig(:errors, 0, :message)
  end
end
