# frozen_string_literal: true

module Types
  module Support
    module BasicRecordType
      include Types::BaseInterface

      field :id, ID, null: false, description: 'The unique identifier of the resource.'
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The date and time that the resource was created.'
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The date and time that the resource was last updated.'
    end
  end
end