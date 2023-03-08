# frozen_string_literal: true

RSpec.shared_context 'with graphql query request' do
 let(:headers)   { {} }
 let(:variables) { {} }
 let(:graphql_params) { { params: { query: query, variables: variables }, headers: headers } }

 def post_request(path = '/graphql')
   post(path, **graphql_params)
 end
end
