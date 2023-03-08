# frozen_string_literal: true

RSpec.shared_context 'login graphql request' do
  let(:login_headers)   { {} }
  let(:login_variables) { {} }
  let(:login_graphql_params) { { params: { query: login, variables: login_variables }, headers: login_headers } }

  def sign_in(path = '/graphql')
    post(path, **login_graphql_params)
  end
end
